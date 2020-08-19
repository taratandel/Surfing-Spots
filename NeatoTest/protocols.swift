//
//  protocols.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation
import UIKit
// MARK: - View -> Presenter
protocol PresenterProtocol: class {
    func getTheNumberOfItemsInSection(section: Int) -> Int
    func getCity(at: IndexPath) -> City
    func mainViewDidLoad()
}

// MARK: - Presenter -> View
protocol CityViewProtocol: class {
    func reloadData()
    func fetchFailed(title: String, message: String, actions: [UIAlertAction])
}
