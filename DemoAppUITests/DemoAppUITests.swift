//
//  DemoAppUITests.swift
//  DemoAppUITests
//
//  Created by Leonardo Geus on 26/12/2017.
//  Copyright © 2017 Leonardo Geus. All rights reserved.
//

import XCTest

class DemoAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test001IfNumberOfCellsIsBiggerThanZero() {
        XCUIApplication().launch()
        XCTAssertTrue(app.collectionViews.cells.count > 0)
    }
    
    func test002IfWith2TapsElementWillGetBigger() {
        
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        let frame = firstChild.frame
        if firstChild.exists {
            firstChild.tap(withNumberOfTaps: 2, numberOfTouches: 1)
            let frame2 = firstChild.frame
            XCTAssertTrue(frame2.width > frame.width)
            XCTAssertFalse(frame2.width < frame.width)
        }
        
    }
    
    func test003IfMoveToOtherCollectionElementItWillBackToYourLastSpace() {
        XCUIApplication().launch()
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 0)
        let frame = firstChild.frame
        if firstChild.exists {
            let secondChild = app.collectionViews.children(matching:.any).element(boundBy: 1)
            firstChild.press(forDuration: 1, thenDragTo: secondChild)
            sleep(2)
            let frame2 = firstChild.frame
            XCTAssertTrue(frame == frame2)
            
        }
        
    }
    
}
