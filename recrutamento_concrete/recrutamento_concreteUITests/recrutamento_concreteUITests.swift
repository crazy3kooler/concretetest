//
//  recrutamento_concreteUITests.swift
//  recrutamento_concreteUITests
//
//  Created by Arilson Carmo on 4/7/16.
//  Copyright © 2016 arilson. All rights reserved.
//

import XCTest

class recrutamento_concreteUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        let app = XCUIApplication()
        app.tables.staticTexts["A powerful image downloading and caching library for Android"].tap()
        app.navigationBars["picasso"].buttons[" "].tap()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
