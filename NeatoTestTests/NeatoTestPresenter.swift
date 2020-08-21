//
//  NeatoTestPresenter.swift
//  NeatoTestTests
//
//  Created by Tara Tandel on 21/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import XCTest
@testable import NeatoTest

class NeatoTestPresenter: XCTestCase {
    /// the real class that we are testing
    var presenter: Presenter!
    /// the mockVC to initiate the presenter
    var vc: MockVC!
    /// the mock model to initiate the presenter
    var model: MockModel!
    
    var client: MockClient!
    
    override func setUpWithError() throws {
        super.setUp()
        self.setUpView(with: false)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        presenter.view = nil
        presenter = nil
        vc = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMainViewDidLoadWhenretrievingDoesntFail() {
        model.dataBennRetrieved = false
        presenter.mainViewDidLoad()
        XCTAssertTrue(model.dataBennRetrieved)
    }
    
    func testMainViewDidLoadWhenretrievingFails() {
        model = MockModel(shouldFail: true)
        presenter.model = model
        model.dataBennRetrieved = true
        presenter.mainViewDidLoad()
        XCTAssertFalse(model.dataBennRetrieved)
    }
    
    func testGetNumberOfItemsInSection() {
        var i = 0
        var citiesDic: [City] = []
        while i < 5 {
            i += 1
            var city = City()
            city.name = "name" + "\(i)"
            city.temp = i
            citiesDic.append(city)
        }
        let model = MockModel(shouldFail: false)
        model.cities = citiesDic
        
        XCTAssertNotNil(presenter.getTheNumberOfItemsInSection(section: 0)==5 )
    }
    
    func testRequestIsCompleteWithEmptyData() {
        presenter.requestIsComplete(Data())
        
        XCTAssertTrue(vc.errorMessage == RequestErrorType.badRequest.localizedDescription)
    }
    
    func testFetchFaildWithNilMessage() {
        presenter.fetchFailed(error: RequestErrorType.badRequest, message: nil)
        XCTAssertTrue(vc.errorMessage == RequestErrorType.badRequest.localizedDescription)
    }
    
    func testFetchFaildWithMessageAndErrorTypeBadRequest() {
        presenter.fetchFailed(error: RequestErrorType.badRequest, message: "this is badRequest")
        XCTAssertTrue(vc.errorMessage == "this is badRequest")

    }
    
    func testFetchFaildWithMessageAndErrorTypeNoInternet() {
        presenter.fetchFailed(error: RequestErrorType.noInternet, message: "you don't have internet")
        XCTAssertTrue(vc.errorMessage == "you don't have internet")
        
    }
    
    func testFetchFaildWithMessageAndErrorTypeServerError() {
        presenter.fetchFailed(error: RequestErrorType.serverError, message: "server Error")
        XCTAssertTrue(vc.errorMessage == "server Error")
        
    }
    
    func testFetchFaildWithMessageAndNoErrorType() {
        presenter.fetchFailed(error: NSError(domain: "some domain", code: 1, userInfo: nil), message: "generic error")
        XCTAssertTrue(vc.errorMessage == "generic error")
        
    }
    
    func testRequestTheCitiesIfNeededModelDicIsEmpty() {
        model.dataBennRetrieved = false
        model.dataBeenSaved = false

        client.shouldRequest(for: "City", with: "json")
        client.requestProtocol = presenter
        
        presenter.requestTheCitiesIfNeeded()
        
        XCTAssertTrue(model.dataBeenSaved)
        XCTAssertTrue(model.dataBennRetrieved)
        XCTAssertTrue(model.arrayTobeSaved.count == 7)
        
    }
    
    func testRequestTheCitiesIfNeededModelDicIsNotEmpty() {
        model.dataBennRetrieved = false
        model.dataBeenSaved = false
    }
    
    func testGetCityWithfullDic () {
        var i = 0
        var citiesDic: [City] = []
        while i < 5 {
            i += 1
            var city = City()
            city.name = "name" + "\(i)"
            city.temp = i
            citiesDic.append(city)
        }
        let model = MockModel(shouldFail: false)
        model.cities = citiesDic
        
        presenter.model = model
        presenter.requestTheCitiesIfNeeded()
        
        XCTAssertTrue(presenter.getCity(at: IndexPath(row: 4, section: 0)).temp == 5 )
    }
    
    func setUpView(with shouldBeEmpty: Bool) {
        client = MockClient()
        vc = MockVC()
        model = MockModel(shouldFail: false)
        presenter = Presenter(view: vc)
        presenter.client = client
        presenter.model = model
        vc.presenter = presenter
    }
    
}
