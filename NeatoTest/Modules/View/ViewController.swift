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
    
    // MARK: - IBOutlets
    
    // MARK: - Presenter
    var presenter: PresenterProtocol?
    
    // MARK: - Private variables
    private let itemsPerRow = 1
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    // MARK: - View Loading cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicatorView(with: "Did you know the best-known product of NeatoRobotics is the Neato XV-series")
        self.presenter = Presenter(view: self)
        setupCollectionView()
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
     func setupCollectionView() {
            (cityCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            (cityCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins

            cityCollectionView.contentInsetAdjustmentBehavior = .always
            
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
            let gestureCell = cityCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CityCollectionViewCell
            guard let cityDataToBuild = presenter?.getCity(at: indexPath) else {
                return UICollectionViewCell()
            }
            gestureCell.fillData(cityDataToBuild)
            return gestureCell
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    extension ViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if indexPath == largePhotoIndexPath {
                var size = collectionView.bounds.size
                size.height -= (sectionInsets.top + sectionInsets.right)
                size.width -= (sectionInsets.left + sectionInsets.right)
                return size
            }

            let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / CGFloat(itemsPerRow)

            return CGSize(width: widthPerItem, height: widthPerItem)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return sectionInsets.left
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
        
    }
    
}


