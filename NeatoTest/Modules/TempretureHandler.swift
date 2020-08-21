//
//  TempretureHandler.swift
//  NeatoTest
//
//  Created by Tara Tandel on 20/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation
/// This class takes care of recurrent requests
class TempretureHandler: RequestServices {
    /// Timer
    private var fetchTimer: Timer?
    /// this is not weak because each presenter must have a client
    private var client: GetDataProtocol?
    /// the protocl that takes care of tem change
    weak var presenter: TempHandlerProtocol?
    /// limit the number of tries for requesting
    private var requestNO: Int = 0
    private var timerInterval: Int = 0
    /**
     Initialized a new temp handler
     - Parameters:
        - presenter: to report the results to
     */
    init(presenter: TempHandlerProtocol, timerInterval: Int) {
        self.presenter = presenter
        self.timerInterval = timerInterval
        client = FetchRemoteData(requestProtocol: self)
    }
    /**
     run the timer and assign a function for each occurnace
     */
    func runTheTimer() {
        fetchTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInterval), target: self, selector: #selector(requestForTheNumber), userInfo: nil, repeats: true)

    }
    /**
     Terminate the allocated timer
     */
    func terminateTheTimer() {
        fetchTimer?.invalidate()
    }
    
    /**
     This function will call for the new temprature
     */
    @objc func requestForTheNumber() {
        client?.getTheListData(url: RequestType.tempratuer(minTemp: "10", maxTemp: "40").path, method: .get, parameter: nil, header: nil)
    }
    /**
     This function will parse the data
     - Parameters:
        - response: the response from the request to be parsed 
     */
    func requestIsComplete(_ response: Data) {
        do {
            let parsedData = try JSONDecoder().decode(RandomNO.self, from: response)
            if parsedData.found ?? false && parsedData.number != nil {
                requestNO = 0
                presenter?.tempChanged(temp: parsedData.number!)
            } else {
                requestNO += 1
                if requestNO < 10 {
                    requestForTheNumber()
                }
            }
        }
        catch {
            requestNO += 1
            if requestNO < 10 {
                requestForTheNumber()
            }
        }
    }
    /**
     will request again for new number
     - Parameters:
        - error: the recieve error
     */
    func requestFaild(_ error: Error) {
        requestNO += 1
        if requestNO < 10 {
            requestForTheNumber()
        }
    }
}
