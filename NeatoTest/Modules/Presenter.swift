//
//  Presenter.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
/// this the presentre class the middler between the networking layer and the entity layer

class Presenter: PresenterProtocol {
    /// this is not weak because each presenter must have a client
    var client: GetDataProtocol?
    /// this protocol is weak because if we don't have a view it's meaningless to have a presenter for it
    weak var view: CityViewProtocol?
    /**
     initializes the presenter class for a given vc
     - Parameters:
        - view: the view for which we are trying to make the presenter for
     - Returns: a new presenter with a new client for the view
     */
    init(view: CityViewProtocol) {
        self.client = FetchRemoteData(requestProtocol: self)
        self.view = view
    }
    /**
     This function will give to the collectionview the needed data
     - Parameters:
        - at: given indexPath for which we need the data
     - Returns: the desired data for that specific indexPath
     */
    func getCity(at: IndexPath) -> City {
        return City.init(name: "cossher")
    }
    /**
     This function will count the number of datas we want the collection view to show
     - Parameters:
        - section: the section number
     -  Returns: a number that indicated the number of desired cells
     */
    func getTheNumberOfItemsInSection(section: Int) -> Int {
        return 2
    }
    
