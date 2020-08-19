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
    
    var citiesDic: [City]?
    /**
     initializes the presenter class for a given vc
     - Parameters:
     - view: the view for which we are trying to make the presenter for
     - Returns: a new presenter with a new client for the view
     */
    init(view: CityViewProtocol) {
        self.client = FetchRemoteData(requestProtocol: self)
        self.view = view
        self.model = CitiesCoreData(modelResultUser: self)
        model?.retrieveFromeCoreData()
    }
    /**
     This function will give to the collectionview the needed data
     - Parameters:
     - at: given indexPath for which we need the data
     - Returns: the desired data for that specific indexPath
     */
    func getCity(at indexPath: IndexPath) -> City {
        return City()
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
    /**
     After the view is completed the it will ask for data and the presenter is reponsilble for netwroking
     
     This function first will check for saved cities if there weren't any it will start the request
     */
    func mainViewDidLoad() {
        guard let citiesDic = model?.cities else {
            client?.getTheListData(url: RequestType.cityList.path, method: .get, parameter: nil, header: nil)
            return
        }
        if citiesDic.count > 0 {
            self.citiesDic = citiesDic
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
                model?.saveToCoreData(array: parsedData)
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
     - message: the message that must be shown to the user
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
        citiesDic = model?.cities
    }
    /**
     This function is the implementation of the ModelResultProtocol which will inform the user of the result of the save action
     it the save was not successful then again the presenter try to fetch the data to save
     
     we don't use alert here because the user does not need to know about the underlying errors
     */
    func saveFailed() {
        self.mainViewDidLoad()
    }
}
