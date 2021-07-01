//
//  NoAlvoUITests.swift
//  NoAlvoUITests
//
//  Created by Bruno Corrêa on 11/06/21.
//

import XCTest

class InTargetUITests: XCTestCase {
    
    func testMain() throws {
        let app = XCUIApplication()
        app.launch()
        
        let closeButton = app.buttons["close_btn"]
        let accountButton = app.buttons["account_btn"]
        let aboutButton = app.buttons["about_btn"]
        let rankingButton = app.buttons["ranking_btn"]
        let hitMeButton = app.buttons["hitMe_btn"]
        let startOverButton = app.buttons["startOver_btn"]
        
        accountButton.tap()
        
        aboutButton.tap()
        aboutButton.tap()
        
        closeButton.tap()
        
        rankingButton.tap()
        sleep(2)
        closeButton.tap()
        
        hitMeButton.tap()
        app.buttons["OK"].tap()
        
        startOverButton.tap()
        sleep(3)
                                                
    }
}
