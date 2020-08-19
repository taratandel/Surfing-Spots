//
//  CommonProtocols.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation
import Alamofire
/// For fetching the result of the service
protocol RequestServices: class {
    func requestIsComplete(_ response: Data)
    func requestFaild(_ error: Error)
}

// MARK: - list services
protocol GetDataProtocol: class {
    func getTheListData(url: String?, method: HTTPMethod,  parameter: Parameters?, header: HTTPHeaders?)
}
