
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
    
    func saveToCoreData(name: String) {
        arrayTobeSaved.append(name)
        dataBeenSaved = !shouldFail
    }
    
    func retrieveFromeCoreData() {
        dataBennRetrieved = !shouldFail
    }
    
    init (shouldFail: Bool) {
        self.shouldFail = shouldFail
    }
    private func fillCitiesMock() {
        for name in arrayTobeSaved {
            var city = City()
            city.name = name
            cities.append(city)
        }
    }
}
