
//
//  File.swift
//  NeatoTestTests
//
//  Created by Tara Tandel on 21/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

@testable import NeatoTest

class MockClient: GetDataProtocol {
    
    weak var requestProtocol: RequestServices?
    var requestShouldFail = false
    var fileName: String = ""
    var fileExtention: String = ""
    var errorType: Error?
    
    var initiated = false
    
    init() {
        self.initiated = true
    }
    
    func getTheListData(url: String?, method: HTTPMethod, parameter: Parameters?, header: HTTPHeaders?) {
        if (errorType != nil) {
            requestProtocol?.requestFaild(errorType!)
        } else if let data = readFromFile() {
            requestProtocol?.requestIsComplete(data)
        } else {
            requestProtocol?.requestIsComplete(Data())
        }
    }

    func shouldRequest(for fileName: String, with fileExtention: String) {
        self.fileName = fileName
        self.fileExtention = fileExtention
    }

    private func readFromFile() -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileExtention) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch  {
                return nil
            }
        }
        return nil
    }
}

class MockVC: CityViewProtocol {

    var dataReloaded = false
    var fetchFailed = false
    var errorMessage = ""
    var rearranged = false
    
    var presenter: PresenterProtocol!
    
    var inited = false
    
    init() {
        self.inited = true
    }
    
    func rearrangeCollectionView(indexToBedeleted: Int, indexToBeInserted: Int) {
        rearranged = true
    }
    
    func fetchFailed(title: String, message: String, actions: [UIAlertAction]) {
        self.errorMessage = message
        fetchFailed = true
    }
    
    func reloadData() {
        dataReloaded = true
    }
    
}

class MockModel: EntityProtocol {
    var cities: [City] = []
    var dataBeenSaved = false
    var shouldFail = false
    var dataBennRetrieved = false
    var arrayTobeSaved: [String] = []
    var shouldFillTemp: Bool = true
    var presenter: ModelResultProtocol?
    
    init (shouldFail: Bool, shouldFillTemp: Bool = true, presenter:  ModelResultProtocol? = nil) {
        self.shouldFail = shouldFail
        self.shouldFillTemp = shouldFillTemp
        self.presenter = presenter
    }
    
    func saveToCoreData(name: String) {
        arrayTobeSaved.append(name)
        dataBeenSaved = !shouldFail
    }
    
    func retrieveFromeCoreData() {
        dataBennRetrieved = !shouldFail
        presenter?.saveWasSuccessful()
    }
    
    func updateModel(newModel: [City]) {
        self.cities = newModel
    }
    
    func fillCitiesMock() {
        for name in arrayTobeSaved {
            var city = City()
            city.name = name
            city.temp = shouldFillTemp ? Int(name):nil
            cities.append(city)
        }
    }
}

class MockTempHandler: PresenterTempratureProtocol {
    var didRequestForTheNumer = false
    var didrunTheTimer = false
    var didTerminateTheTimer = false
    var presenter: TempHandlerProtocol?

    init(presenter: TempHandlerProtocol? = nil) {
        self.presenter = presenter
    }
    
    func requestForTheNumber() {
        self.didRequestForTheNumer = true
        presenter?.tempChanged(temp: 30)
    }
    
    func runTheTimer() {
        self.didrunTheTimer = true
        presenter?.tempChanged(temp: 30)
    }
    
    func terminateTheTimer() {
        didTerminateTheTimer = true
    }
    
    
}
