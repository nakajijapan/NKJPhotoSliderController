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
    
    func existsPhotoSliderScrollView(app: XCUIApplication) {
        
        sleep(1)
        XCTAssertEqual(app.scrollViews.matchingIdentifier("NKJPhotoSliderScrollView").element.exists, false)
        
    }
    
    func testPushCloseButtonExample() {
        
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        XCTAssertEqual(app.scrollViews.matchingIdentifier("NKJPhotoSliderScrollView").element.exists, true)
        
        app.buttons["NKJPhotoSliderControllerClose"].tap()
        
        self.existsPhotoSliderScrollView(app)
    }
    
    func testSwitchImage() {
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        let element = app.scrollViews.matchingIdentifier("NKJPhotoSliderScrollView").elementBoundByIndex(0)
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
        
        let element = app.scrollViews.matchingIdentifier("NKJPhotoSliderScrollView").elementBoundByIndex(0)
        element.swipeUp()
        
        self.existsPhotoSliderScrollView(app)
    }
    
    func testCloseWithSwipingDownImage() {
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        let element = app.scrollViews.matchingIdentifier("NKJPhotoSliderScrollView").elementBoundByIndex(0)
        element.swipeDown()
        
        self.existsPhotoSliderScrollView(app)
    }
    
    func testRightRotation() {
        
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        let element = app.scrollViews.matchingIdentifier("NKJPhotoSliderScrollView").elementBoundByIndex(0)
        element.swipeLeft()
        element.swipeLeft()
        
        XCUIDevice.sharedDevice().orientation = .LandscapeRight
        XCUIDevice.sharedDevice().orientation = .PortraitUpsideDown
        XCUIDevice.sharedDevice().orientation = .LandscapeLeft
        XCUIDevice.sharedDevice().orientation = .Portrait
        app.buttons["NKJPhotoSliderControllerClose"].tap()
    }
    
    func testZooming() {
        XCUIDevice.sharedDevice().orientation = .Portrait
        
        let app = XCUIApplication()
        app.otherElements["rootView"].tap()
        
        let element = app.scrollViews.matchingIdentifier("NKJPhotoSliderScrollView").elementBoundByIndex(0)
        element.doubleTap()
        element.swipeUp()
        element.swipeDown()
        element.doubleTap()
        app.buttons["NKJPhotoSliderControllerClose"].tap()
        
        self.existsPhotoSliderScrollView(app)
    }
    
}