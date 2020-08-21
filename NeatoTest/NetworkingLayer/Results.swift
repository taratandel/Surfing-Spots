//
//  Results.swift
//  NeatoTest
//
//  Created by Tara Tandel on 19/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation
/// the possible error when we are requesting
public enum RequestErrorType: Error {
    case noInternet
    case badRequest
    case serverError
}
/// the result types
enum Result<T> {
    case success(T)
    case failure(RequestErrorType)
}
