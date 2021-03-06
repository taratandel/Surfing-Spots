//
//  ViewController.swift
//  NeatoTest
//
//  Created by Tara Tandel on 18/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    // MARK: - Presenter
    var presenter: PresenterProtocol?
    
    // MARK: - Private variables
    private let itemsPerRow = 1
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    // MARK: - View Loading cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicatorView(with: "Did you know the best-known product of NeatoRobotics is the Neato XV-series")
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        presenter?.mainViewDidLoad()
        
    }
    
    func setupCollectionView() {
//        cityCollectionView.contentInsetAdjustmentBehavior = .always
        self.cityCollectionView?.alwaysBounceVertical = true
        cityCollectionView?.delegate = self
        cityCollectionView?.dataSource = self
    }
    
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getTheNumberOfItemsInSection(section: section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cityCell = cityCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CityCollectionViewCell
        guard let cityDataToBuild = presenter?.getCity(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        cityCell.fillData(cityDataToBuild, collectionView.bounds.width)
//        cityCell.layoutIfNeeded()
        return cityCell
    }
}

// MARK: - CityViewProtocol
extension ViewController: CityViewProtocol {
    /**
     This function will rearrange collection view cells
     - Parameters:
     - indexToBeDeleted: the source point for moving
     - indexToBeInserted: the destination point for moving
     */
    func rearrangeCollectionView(indexToBedeleted: Int, indexToBeInserted: Int) {
        DispatchQueue.main.async {
//            self.view.isUserInteractionEnabled = false
            self.cityCollectionView.performBatchUpdates({
                self.cityCollectionView.deleteItems(at: [IndexPath(row: indexToBedeleted, section: 0)])


        }, completion:{ [weak self] _ in
            self?.cityCollectionView.performBatchUpdates({
                self?.cityCollectionView.insertItems(at: [IndexPath(row: indexToBeInserted, section: 0)])
            }, completion: { [weak self] _ in
                self?.view.isUserInteractionEnabled = true
            })})
        }
    }
    
    /**
     when all the datas are fetched this will reload the view the proper datas
     */
    func reloadData() {
        removeIndicator()
        cityCollectionView?.reloadData()
        cityCollectionView?.layoutIfNeeded()
        definesPresentationContext = true
    }
    /**
     This function will show an alert when the request got failed
     - Parameters:
     - title: The title to show
     - message: The message to show inside the alert
     - actions: a set of actions to create the buttons
     */
    func fetchFailed(title: String, message: String, actions: [UIAlertAction]) {
        removeIndicator()
        showAlert(title: title, message: message, actions: actions)
    }
    
}


