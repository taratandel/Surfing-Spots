//
//  TopLevelHelper.swift
//  NeatoTestTests
//
//  Created by Tara Tandel on 21/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import XCTest
import UIKit
/// this class will prevent the view to be loaded
class TopLevelUIUtilities<T: UIViewController> {
    
    private var rootWindow: UIWindow!
    /// sets the root view controller to the desired view controller
    func setupTopLevelUI(withViewController viewController: T) {
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        rootWindow.rootViewController = viewController
        _ = viewController.view
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
    }
    /// removes the view controller 
    func tearDownTopLevelUI() {
        guard let rootWindow = rootWindow,
            let rootViewController = rootWindow.rootViewController as? T else {
                XCTFail("tearDownTopLevelUI() was called without setupTopLevelUI() being called first")
                return
        }
        rootViewController.viewWillDisappear(false)
        rootViewController.viewDidDisappear(false)
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
}
