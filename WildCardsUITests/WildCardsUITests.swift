//
//  WildCardsUITests.swift
//  WildCardsUITests
//
//  Created by Ø on 04/07/2017.
//  Copyright © 2017 mainvolume. All rights reserved.
//

import XCTest

class WildCardsUITests: XCTestCase {
    
    var app : XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUIDragExample() {
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        let loadingSwipeToViewStaticText = app.staticTexts["loading. swipe to view"]
        loadingSwipeToViewStaticText.swipeRight()
        loadingSwipeToViewStaticText.swipeRight()
        app.otherElements.containing(.staticText, identifier:"Count: 39").children(matching: .other).element.swipeRight()
        
        let thisIsAMockTapToExitStaticText = app.staticTexts["This is a Mock Tap to exit"]
        thisIsAMockTapToExitStaticText.tap()
        app.staticTexts["Name: Kristin Schulze"].swipeLeft()
        app.staticTexts["City: Linkenbach"].swipeLeft()
        
        let whishesKidsYesStaticText = app.staticTexts["Whishes kids: Yes"]
        whishesKidsYesStaticText.swipeLeft()
        whishesKidsYesStaticText.swipeLeft()
        app.staticTexts["Smokes: Yes"].swipeLeft()
        app.staticTexts["City: Kaiserslautern Morlautern"].swipeLeft()
        app.staticTexts["City: Manderscheid"].swipeRight()
        app.staticTexts["Smokes: No"].swipeRight()
        whishesKidsYesStaticText.swipeRight()
        thisIsAMockTapToExitStaticText.tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
