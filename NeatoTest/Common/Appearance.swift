//
//  Appearance.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import UIKit

/// sets the global appearance for the app
final class Appearances {
    /**
     This function will change the fonr and tint color for some elements in the application
     
     Change the font for tabBar (if any);
     
     Change the fornt of the searchBar (if any);
     
     Chnage the font of the buttins in normal state(if any);
     
     Chnage the font of the buttins in highlighted state(if any);
     
     Change the tint color of the button;
     
     Change the tint color for the navigationBar;
     */
    class func setGlobalAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont(isBold: false, withSize: 10)], for: .normal)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.font: UIFont.defaultFont]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchController.self]).defaultTextAttributes = [NSAttributedString.Key.font: UIFont.defaultFont]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont(isBold: false, withSize: 17)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont(isBold: false, withSize: 17)], for: .highlighted)
        UIBarButtonItem.appearance().tintColor = UIColor.red
        UINavigationBar.appearance().tintColor = .white
    }
}


/// This extention will add 2 fonts
extension UIFont {
    /**
     Initionizes a new font with two different state (bod, normal)
     - Parameters:
            - isBold: Indicate the state of the font
            - withSize size: Indicate the size of the font
     - Returns: A brand new font with desired state and size
     */
    convenience init(isBold: Bool, withSize size: CGFloat) {
        self.init(name: isBold ? "ComicSansMS-Bold" : "Comic Sans MS", size: size)!
    }
    /// default font of the app
    static var defaultFont: UIFont {
        return UIFont(isBold: false, withSize: 15)
    }
    /// bod font of the app
    static var boldFont: UIFont {
        return UIFont(isBold: true, withSize: 15)
    }
}

extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}

extension UIColor {
    static var lightBlue: UIColor {
        return UIColor(red: 158/256, green: 224/256, blue: 255/256, alpha: 1)
    }
}

