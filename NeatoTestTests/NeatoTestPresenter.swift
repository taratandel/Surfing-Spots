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
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func setUpView(with shouldBeEmpty: Bool) {
        let client = MockClient()
        vc = MockVC()
        presenter = GestureListPresenter(wireFrame: wireFrame, interector: interector, client: client)
        presenter.view = vc
        vc.presenter = presenter
        interector.presenter = presenter
    }

}
