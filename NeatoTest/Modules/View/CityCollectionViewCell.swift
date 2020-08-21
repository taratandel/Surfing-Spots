//
//  CityCollectionViewCell.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import UIKit
//import SDWebImage

class CityCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    
    // MARK: - private variables
    private var temp = 0
    
    // MARK: - cell initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    /**
     This function will fill the cell
     - Parameters:
     - city: The city data
     - width: The width of the cell
     */
    func fillData (_ city: City, _ width: CGFloat) {
        let weatherString = city.temp ?? 0 > 30 ? "Sunny - ": "Cloudy - "
        if city.temp != temp {
            
            // MARK: - corner radius
            self.contentView.layer.cornerRadius = 5.0
            self.contentView.layer.borderWidth = 1.0
            self.contentView.layer.borderColor = UIColor.clear.cgColor
            self.contentView.layer.masksToBounds = true
            
            // MARK: - shadow
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            self.layer.shadowRadius = 2.0
            self.layer.shadowOpacity = 0.5
            self.layer.masksToBounds = false
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
            
            // MARK: - background image
            self.cityImage.isHidden = city.temp ?? 0 < 30
            self.cityImage.image = UIImage(named: city.name ?? "PlaceHolder")
            self.cityImage.backgroundColor = .gray

            
            // This implementation is for remote fetching
            //        let width = Int(width)
            //        if city.temp != temp {
            //            temp = city.temp ?? 0
            //            self.cityImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //            let requestString = city.temp ?? 0 > 30 ? RequestType.randomPicFresh(height: "\(width/2)", width: "\(width)", randomNO: "\(String(describing: city.temp))").path:RequestType.randomPicGrayScale(height: "\(width/2)", width: "\(width)", randomNO: "\(String(describing: city.temp))").path
            //            self.cityImage.sd_setImage(with: URL(string: requestString), placeholderImage: UIImage(named: "PlaceHolder"), options: .progressiveLoad, completed: {
            //                (_,_,_,_) in
            //
            //            })
            //        }
            
            // MARK: - city Name
            self.cityName.text = city.name!
            self.cityName.font = UIFont.boldFont
            self.cityName.font = self.cityName.font.withSize(28)
            self.cityName.textColor = .white
            
            // MARK: - city Temp
            self.cityTemp.text = weatherString + "\(city.temp!)"
            self.cityTemp.font = UIFont.defaultFont
            self.cityTemp.textColor = .white
        }
    }
}
