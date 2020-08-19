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
    
    private let itemsPerRow = 1
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicatorView(with: "Wait :/")
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
        }

    }

extension ViewController: CityViewProtocol {
    func reloadData() {
        
    }
    
    func fetchFailed(title: String, message: String, actions: [UIAlertAction]) {
        
    }
    
}


