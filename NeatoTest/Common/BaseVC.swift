//
//  BaseVC.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import UIKit
/// base view for the application, this view consists of neccessary functions which should be done in every every controller
class BaseViewController: UIViewController {
    var indicatorView: IndicatorViewController?
    // MARK: View settings
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }
    /**
     Show in indicatorView on top of the view
     - Parameters:
        - text: the text that you want to show the user
     */
    func showIndicatorView(with text: String) {
        indicatorView = IndicatorViewController(indicatorMessage: text)
        guard let indicator = indicatorView else {return}
        indicator.view.frame = self.view.frame
        self.view.addSubview(indicator.view)
        self.view.bringSubviewToFront(indicator.view)
    }
    /**
     removes the current indicator view (if any) and deallocate the view
     */
    func removeIndicator() {
        indicatorView?.view.removeFromSuperview()
        indicatorView = nil
    }

}
