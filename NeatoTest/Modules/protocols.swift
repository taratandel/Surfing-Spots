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
protocol PresenterProtocol {
    func getTheNumberOfItemsInSection(section: Int) -> Int
    func getCity(at indexPath: IndexPath) -> City
    func mainViewDidLoad()
}

// MARK: - Presenter -> View
protocol CityViewProtocol: class {
    func reloadData()
    func fetchFailed(title: String, message: String, actions: [UIAlertAction])
}
// MARK: - WireFrame Protocol
protocol WireFrameProtocol {
    static func creatTheView(_ viewRef: ViewController)
}

// MARK: - Presenter -> Entity
protocol EntityProtocol {
    var cities: [City]  {get set}
    func saveToCoreData(array: CitiesDic)
    func retrieveFromeCoreData()
}

// MARK: - Entity -> Presenter
protocol ModelResultProtocol: class {
    func saveWasSuccessful()
    func saveFailed()
}

// MARK: - TempHandler -> Presenter
protocol TempHandlerProtocol: class {
    func tempChanged(temp: Int)
}
