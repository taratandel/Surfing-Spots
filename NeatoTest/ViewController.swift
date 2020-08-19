//
//  ViewController.swift
//  NeatoTest
//
//  Created by Tara Tandel on 18/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var cityCollectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    var presenter: PresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicatorView(with: "Wait :/")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        presenter?.mainViewDidLoad()

    }
    
