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
    func rearrangeCollectionView(indexToBedeleted: Int, indexToBeInserted: Int)
}

// MARK: - Presenter -> Entity
protocol EntityProtocol: class {
    var cities: [City]  {get set}
    func saveToCoreData(name: String)
    func retrieveFromeCoreData()
    func updateModel(newModel: [City])
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

// MARK: - Presenter -> TempHanlder
protocol PresenterTempratureProtocol: class {
    func requestForTheNumber()
    func runTheTimer()
    func terminateTheTimer()
}
