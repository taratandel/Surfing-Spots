//
//  CityCollectionViewCell.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import UIKit
import SDWebImage

class CityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    private var city: City
    override var isSelected: Bool {
        didSet {
            cityImage.layer.borderWidth = isSelected ? 10 : 2
            cityImage.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.blue.cgColor
            
        }
    }
    
    override func awakeFromNib() {
        isSelected = false
        super.awakeFromNib()
    }
    
    func fillData (_ city: City) {
        self.city = city
        imageLoader.startAnimating()
        self.cityImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.cityImage.backgroundColor = .red
        self.cityName.text = city.name
        self.cityName.backgroundColor = .darkGray
        self.cityName.textColor = .white
        self.backgroundColor = .black
    }
    
    func changeTheTemprature(_ temp: Int) {
        self.cityImage.sd_setImage(with: URL(string: "https://images.app.goo.gl/AdXXAUfem1iPzB1x7"), placeholderImage: UIImage(named: "PlaceHolder"), options: .progressiveLoad, completed: {
            [weak self]  (_,_,_,_) in
            self?.imageLoader.isHidden = true
        })
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutAttributes.bounds.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        return layoutAttributes
    }
    
}
