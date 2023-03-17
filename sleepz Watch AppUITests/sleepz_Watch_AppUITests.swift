//
//  sleepz_Watch_AppUITests.swift
//  sleepz Watch AppUITests
//
//  Created by Burhan Drak Sibai on 1/31/23.
//

import XCTest

final class sleepz_Watch_AppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let welcomeText = app.staticTexts["Welcome to Sleepz"]
        XCTAssert(welcomeText.exists)
        
        let nextButton = app.buttons["nextButton"]
        XCTAssert(nextButton.exists)
        
        nextButton.tap()
        
        let createAlarmButton = app.buttons["createAlarmButton"]
        XCTAssert(createAlarmButton.exists)
        
        createAlarmButton.tap()
        
        let setStartTimeText = app.staticTexts["Set wake up window start"]
        XCTAssert(setStartTimeText.exists)
        
        let selectEndTimeButton = app.buttons["setAlarmEnd"]
        XCTAssert(selectEndTimeButton.exists)
        
        selectEndTimeButton.tap()
        
        let setEndTimeText = app.staticTexts["Set wake up window end"]
        XCTAssert(setEndTimeText.exists)
        
        let alarmCreationButton = app.buttons["finishCreationButton"]
        XCTAssert(alarmCreationButton.exists)
        
        alarmCreationButton.tap()
        
        let alarmWindowTime = app.staticTexts["1:00 - 1:00am"]
        let alarmWindowLengthTime = app.staticTexts["0 min window"]
        XCTAssert(alarmWindowTime.exists)
        XCTAssert(alarmWindowLengthTime.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
