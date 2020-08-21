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
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
    /**
     show an alert with specified actions
     - Parameters:
        - title: the title of the alert
        - message: the message of the alert
        - action: an array of desired actions to be done by the alert
        - completion: a handler for call back of the action (the defalut value in nil)
     - Returns:
     will present an alert with a list of actions 
     */
    func showAlert(title: String, message: String, actions: [UIAlertAction], completion: (() -> Void)? = nil)  {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach{alertController.addAction($0)}
        self.present(alertController, animated: true, completion: completion)
    }
    
    /**
     This function will set the navigation bar title size , by default it is large
     
     - Parameters:
        - isBig: set true if you want large navigation item bar title
     */
    func setNavigationBarTitleSizePreference(isBig: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = isBig

    }
}
