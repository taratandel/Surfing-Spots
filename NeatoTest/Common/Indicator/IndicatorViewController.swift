//
//  IndicatorViewController.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import UIKit

/// This view will show and indicator with a desired text
class IndicatorViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    // MARK: parameter
    private var indicatorLabelText: String?
    
    // MARK: View settings
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        indicatorLabel.text = indicatorLabelText
        // Do any additional setup after loading the view.
    }
    
    /**
     Initialiazes a viewController which shows a spinner until the main view is loaded
     - Parameters:
        -   indicatorMessage: The message to be shown at the bottom of the indicator
     - Returns:
     a vc with a apinner and a text that goes on top of your view
     */
    init(indicatorMessage: String) {
        self.indicatorLabelText = indicatorMessage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    deinit {
        self.indicatorLabelText = nil
    }
}
