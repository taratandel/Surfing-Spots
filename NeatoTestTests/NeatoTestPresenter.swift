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
        presenter.requestTheCitiesIfNeeded()
        
        XCTAssertNotNil(presenter.getCity(at: IndexPath(row: 4, section: 0)) )
    }
    
    func setUpView(with shouldBeEmpty: Bool) {
        let client = MockClient()
        vc = MockVC()
        let model = MockModel(shouldFail: false)
        presenter = Presenter(view: vc)
        presenter.client = client
        presenter.model = model
        vc.presenter = presenter
    }

}
