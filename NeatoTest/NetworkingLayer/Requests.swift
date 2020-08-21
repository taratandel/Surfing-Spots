//
//  Requests.swift
//  NeatoTest
//
//  Created by Tara Tandel on 18/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation
import Alamofire
/// the path for the requests based on the given parameters
enum RequestType {
    case cityList
    case tempratuer(minTemp: String, maxTemp: String)
    
    var path: String {
        switch self {
        case .cityList:
            return String(format: "%@/652ceb94-b24e-432b-b6c5-8a54bc1226b6", EndPoints.citiesSeverEndPoint)
        case let .tempratuer(minTemp, maxTemp):
            return String(format: "%@/random?min=%@&max=%@&json", EndPoints.randomServerEndPoint, minTemp, maxTemp)
        }
    }
}
/// this class is for networking
class FetchRemoteData {
    weak var requestProtocol: RequestServices?
    /**
     initializes a client for the given protocol
     - Parameters:
        - requestProtocol: the class that we want the client to be initialized for
     */
    init(requestProtocol: RequestServices) {
        self.requestProtocol = requestProtocol
    }
    /**
     This private function will handle all types of request pased in methods
     - Parameters:
        - url: the API url string
        - method: The method for the request can be:
            - GET
            - POST
            - Delete
            - PUT and more
        - parameter: of there are specific parameter that we shoudl send to the server usually at post or delet or put requests
        - header: specific hearder for caching authenticating and etc...
        - completionHandler: the call back function
     */
    private func request (url: String?, method: HTTPMethod,  parameter: Parameters?, header: HTTPHeaders?, completionHandler: @escaping (_ result: AFDataResponse<Any>) -> Void) {
        if let reqURL = url {
            AF.request(reqURL, method: method, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON {
                response in
                completionHandler(response)
                
            }
        }
    }
}
/// this is an extension will do a request and part the data based on the given presenter
extension FetchRemoteData: GetDataProtocol {
    func getTheListData(url: String?, method: HTTPMethod, parameter: Parameters?, header: HTTPHeaders?) {
        self.request(url: url, method: method, parameter: parameter, header: header) {
            response in
            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    self.requestProtocol?.requestFaild(RequestErrorType.badRequest)
                    return
                }
                self.requestProtocol?.requestIsComplete(data)
            case .failure(let error):
                self.requestProtocol?.requestFaild(error)
                
            }
        }
    }
}
