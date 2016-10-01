//
//  NKJPhotoSliderControllerUITests.swift
//  NKJPhotoSliderControllerUITests
//
//  Created by nakajijapan on 2015/10/29.
//  Copyright 2015 nakajijapan. All rights reserved.
//

import XCTest

class NKJPhotoSliderControllerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
        
        XCUIApplication().terminate()
    }
    
    func existsPhotoSliderScrollView(_ app: XCUIApplication) {
        
        sleep(1)
        XCTAssertEqual(app.scrollViews.matching(identifier: "NKJPhotoSliderScrollView").element.exists, false)
        
    }
    
    func testPushCloseButtonExample() {
        
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        XCTAssertEqual(app.scrollViews.matching(identifier: "NKJPhotoSliderScrollView").element.exists, true)
        
        app.buttons["NKJPhotoSliderControllerClose"].tap()
        
        self.existsPhotoSliderScrollView(app)
    }
    
    func testSwitchImage() {
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        let element = app.scrollViews.matching(identifier: "NKJPhotoSliderScrollView").element(boundBy: 0)
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeRight()
        element.swipeRight()
        element.swipeRight()
        app.buttons["NKJPhotoSliderControllerClose"].tap()
        
        self.existsPhotoSliderScrollView(app)
    }
    
    func testCloseWithSwipingUpImage() {
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        let element = app.scrollViews.matching(identifier: "NKJPhotoSliderScrollView").element(boundBy: 0)
        element.swipeUp()
        
        self.existsPhotoSliderScrollView(app)
    }
    
    func testCloseWithSwipingDownImage() {
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        let element = app.scrollViews.matching(identifier: "NKJPhotoSliderScrollView").element(boundBy: 0)
        element.swipeDown()
        
        self.existsPhotoSliderScrollView(app)
    }
    
    func testRightRotation() {
        
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        let element = app.scrollViews.matching(identifier: "NKJPhotoSliderScrollView").element(boundBy: 0)
        element.swipeLeft()
        element.swipeLeft()
        
        XCUIDevice.shared().orientation = .landscapeRight
        XCUIDevice.shared().orientation = .portraitUpsideDown
        XCUIDevice.shared().orientation = .landscapeLeft
        XCUIDevice.shared().orientation = .portrait
        app.buttons["NKJPhotoSliderControllerClose"].tap()
    }
    
    func testZooming() {
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        let element = app.scrollViews.matching(identifier: "NKJPhotoSliderScrollView").element(boundBy: 0)
        element.doubleTap()
        element.swipeUp()
        element.swipeDown()
        element.doubleTap()
        app.buttons["NKJPhotoSliderControllerClose"].tap()
        
        self.existsPhotoSliderScrollView(app)
    }
    
}
