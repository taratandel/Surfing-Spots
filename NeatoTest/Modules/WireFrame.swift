//
//  WireFrame.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation

/// A class for routing inside the application
class WireFrame: GestureListWireFramProtocol {
    /**
     Initializes the given VC and assigns the suitable presenter to it.
     - Parameters:
        - viewRef: The initial view controller
     */
    class func creatTheView(_ viewRef: ViewController) {
                
        let presenter = Presenter(view: viewRef)
        
        viewRef.presenter = presenter
    }
}
