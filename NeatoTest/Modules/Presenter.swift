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
    /// this is the coredata class
    var model: EntityProtocol?
    /// the local copy of the array of cities
    private var citiesDic: [City]?
    /// handler for temprature
    var tempHandler: PresenterTempratureProtocol?
    
    /// avoid reloading the view each time a temp is loaded
    private var viewIsReloaded = false
    
    /// keeps track of assigned tempratures
    private var lastUpdatedIndex = 0
    
    /// keeps track of last random number
    private var lastUpdatedCity: [String] = []
    
    
    /**
     initializes the presenter class for a given vc
     - Parameters:
        - view: the view for which we are trying to make the presenter for
     - Returns: a new presenter with a new client for the view
     */
    init(view: CityViewProtocol) {
        self.view = view
    }
    /**
     This function will give to the collectionview the needed data
     - Parameters:
        - at indexPath: given indexPath for which we need the data
     - Returns: the desired data for that specific indexPath
     */
    func getCity(at indexPath: IndexPath) -> City {
        return citiesDic?[indexPath.row] ?? City()
    }
    /**
     This function will count the number of datas we want the collection view to show
     - Parameters:
        - section: the section number
     -  Returns: a number that indicated the number of desired cells
     */
    func getTheNumberOfItemsInSection(section: Int) -> Int {
        return citiesDic?.count ?? 0
    }
    /**
     After the view is completed the it will ask for data and the presenter is reponsilble for netwroking
     
     This function first will check for saved cities if there weren't any it will start the request
     */
    func mainViewDidLoad() {
        model?.retrieveFromeCoreData()
    }
    /**
     This function will check for any preexisting data on data base and make the proper request if needed
     */
    func requestTheCitiesIfNeeded() {
        guard let citiesDic = model?.cities else {
            client?.getTheListData(url: RequestType.cityList.path, method: .get, parameter: nil, header: nil)
            return
        }
        if citiesDic.count > 0 {
            self.citiesDic = citiesDic
            requestForTemps()
        } else {
            client?.getTheListData(url: RequestType.cityList.path, method: .get, parameter: nil, header: nil)
        }
    }
}
/// The necessary functions for networking after the request is complete the presenter is responsible for data convertion and also for the connection between the entity
extension Presenter: RequestServices {
    /**
     The implementation of the protocol function when the request is complete
     
     based on the result of parsing the failure or success will be concluded
     - Parameters:
        - respnse: data type for parsing
     */
    func requestIsComplete(_ response: Data) {
        do {
            let parsedData = try JSONDecoder().decode(CitiesDic.self, from: response)
            if parsedData.cities?.count ?? 0 > 0 {
                for city in parsedData.cities!{
                    model?.saveToCoreData(name: city.name ?? "a city")
                }
                model?.retrieveFromeCoreData()
            } else {
                self.fetchFailed(error: RequestErrorType.serverError, message: "req failed")
            }
        }
        catch {
            self.fetchFailed(error: RequestErrorType.badRequest, message: nil)
        }
    }
    /**
     The implementation of the protocol function when the request fails
     - Parameters:
        - error: Error type when request fails
     */
    func requestFaild(_ error: Error) {
        self.fetchFailed(error: error, message: nil)
    }
    /**
     this function will show an alerts based on the result of the failed request
     - Parameters:
        - error: the Error type when there are an error
        -  message: the message that must be shown to the user
     */
    func fetchFailed(error: Error, message: String?) {
        if message != nil {
            switch error {
            case RequestErrorType.badRequest:
                let actions = [UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                })]
                view?.fetchFailed(title: "Request Error", message: message!, actions: actions)
            case RequestErrorType.noInternet:
                let actions = [UIAlertAction(title: "Retry", style: .cancel, handler: { [weak self](action) in
                    self?.mainViewDidLoad()
                })]
                view?.fetchFailed(title: "NO Internet", message: message!, actions: actions)
            case RequestErrorType.serverError:
                let actions = [UIAlertAction(title: "Retry", style: .cancel, handler: { [weak self](action) in
                    self?.mainViewDidLoad()
                })]
                view?.fetchFailed(title: "Server Error", message: message!, actions: actions)
            default:
                let actions = [UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                })]
                view?.fetchFailed(title: "Request Failed", message: message!, actions: actions)
            }
        } else {
            let actions = [UIAlertAction(title: "Retry", style: .cancel, handler: { [weak self](action) in
                self?.mainViewDidLoad()
            })]
            view?.fetchFailed(title: "Oops", message: error.localizedDescription, actions: actions)
        }
    }
}

/// this extention will handle manupulating the data and has the responsibility to connect to entity
extension Presenter: ModelResultProtocol {
    /**
     This function is the implementation of the ModelResultProtocol which will inform the user of the result of the save action
     if it was successfull then we assign the retrieved data to our class variable
     */
    func saveWasSuccessful() {
        self.requestTheCitiesIfNeeded()
        requestForTemps()
    }
    /**
     This function is the implementation of the ModelResultProtocol which will inform the user of the result of the save action
     it the save was not successful then again the presenter try to fetch the data to save
     
     we don't use alert here because the user does not need to know about the underlying errors
     */
    func saveFailed() {
        self.requestTheCitiesIfNeeded()
    }
}

extension Presenter: TempHandlerProtocol {
    
    func requestForTemps() {
        tempHandler?.requestForTheNumber()
    }
    
    func tempChanged(temp: Int) {
        guard let cities = citiesDic else {
            requestTheCitiesIfNeeded()
            return
        }
        if !viewIsReloaded {
            if lastUpdatedIndex < cities.count {
                let city = cities[lastUpdatedIndex]
                if city.temp == nil {
                    var newCity = city
                    newCity.temp = temp
                    citiesDic?.remove(at: lastUpdatedIndex)
                    citiesDic?.insert(newCity, at: lastUpdatedIndex)
                    lastUpdatedIndex += 1
                    tempHandler?.requestForTheNumber()
                }
            }else {
                self.viewIsReloaded = true
                self.citiesDic = cities.sorted(by: { $0.temp! > $1.temp! })
                model?.updateModel(newModel: self.citiesDic!)
                view?.reloadData()
                tempHandler?.runTheTimer()
            }
            
        } else {
            /// random genrator
            var randomNO = Int.random(in: 0...(cities.count - 1))
            
            /// copy of the city that is changing
            var newCity = cities[randomNO]
            if lastUpdatedCity.count == cities.count { lastUpdatedCity.removeAll()}
            
            while lastUpdatedCity.contains(newCity.name ?? "") {
                randomNO = Int.random(in: 0...(cities.count - 1))
                newCity = cities[randomNO]
            }
            lastUpdatedCity.append(newCity.name ?? "")
            newCity.temp = temp
            
            /// copy of the array of cities to leave the actual source untouched if there were a reading during update
            var copyCity = cities
            copyCity.remove(at: randomNO)
            
            /// the indexpath.row of the new city
            var indexToBeInserted = 0
            
            // check for the place that the new city should go
            if let index = copyCity.firstIndex(where: {$0.temp! < temp}) {
                indexToBeInserted = index + 1
                copyCity.insert(newCity, at: index)
            } else {
                indexToBeInserted = copyCity.count
                copyCity.append(newCity)
            }
            
            // check if insertion was done without any error
            if copyCity.count == citiesDic?.count ?? 0 {
                citiesDic = copyCity
            }
            model?.updateModel(newModel: citiesDic)
            if randomNO == indexToBeInserted {return}
            // rearrange the view afteer the update of the source
            view?.rearrangeCollectionView(indexToBedeleted: randomNO, indexToBeInserted: indexToBeInserted)
        }
    }
}
