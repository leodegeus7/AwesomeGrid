//
//  GridLayoutTests.swift
//  GridLayoutTests
//
//  Created by Leonardo Geus on 26/12/2017.
//  Copyright © 2017 Leonardo Geus. All rights reserved.
//

import XCTest
@testable import GridLayout

class GridLayoutTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddSquareElement() {
        let positionInfo = PositionInfoManager(numberOfColumns: 4, frame: CGRect(x: 0, y: 0, width: 450, height: 750))
        let elementRight = Element(row: 0, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let elementWrong = Element(row: 6, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        XCTAssertTrue(positionInfo.addElement(element: elementRight))
        XCTAssertFalse(positionInfo.addElement(element: elementWrong))
    }
    
    func testCreateZeroMatrix() {
        let positionInfo = PositionInfoManager(numberOfColumns: 4, frame: CGRect(x: 0, y: 0, width: 450, height: 750))
        
        XCTAssertTrue(positionInfo.columnSize > 100 && positionInfo.columnSize < 130)
    }
    
    func testGetNumberOfItens() {
        let positionInfo = PositionInfoManager(numberOfColumns: 4, frame: CGRect(x: 0, y: 0, width: 450, height: 750))
        let elementRight = Element(row: 0, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let elementRight2 = Element(row: 1, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let _ = positionInfo.addElement(element: elementRight)
        let _ = positionInfo.addElement(element: elementRight2)
        XCTAssertTrue(positionInfo.getNumberOfItens() == 2)
        XCTAssertFalse(positionInfo.getNumberOfItens() == 0)
    }
    
    func testElementsInfo() {
        let positionInfo = PositionInfoManager(numberOfColumns: 4, frame: CGRect(x: 0, y: 0, width: 450, height: 750))
        let elementRight = Element(row: 0, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let elementRight2 = Element(row: 1, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let _ = positionInfo.addElement(element: elementRight)
        let _ = positionInfo.addElement(element: elementRight2)
        XCTAssertTrue(positionInfo.getElementsInfo().count == 2)
    }
    

    
    func testThereIsElementInSpace() {
        let positionInfo = PositionInfoManager(numberOfColumns: 4, frame: CGRect(x: 0, y: 0, width: 450, height: 750))
        let elementRight = Element(row: 0, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let elementTest = Element(row: 6, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        
        let _ = positionInfo.addElement(element: elementRight)
        XCTAssertTrue(positionInfo.thereIsElementInSpace(element: elementRight))
        XCTAssertFalse(positionInfo.thereIsElementInSpace(element: elementTest))
        
    }
    
    func testResizeCell() {
        let positionInfo = PositionInfoManager(numberOfColumns: 4, frame: CGRect(x: 0, y: 0, width: 450, height: 750))
        let elementRight = Element(row: 0, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let _ = positionInfo.addElement(element: elementRight)
        let _ = positionInfo.resizeCell(element: elementRight, newHeight: 2, newWidth: 2)
        let elementTest = Element(row: 0, column: 0, squaresOfWidth: 2, squaresOfHeight: 2)
        XCTAssertTrue(positionInfo.thereIsElementInSpace(element: elementTest))
    }
    
    func testRemoveElement() {
        let positionInfo = PositionInfoManager(numberOfColumns: 4, frame: CGRect(x: 0, y: 0, width: 450, height: 750))
        let elementRight = Element(row: 0, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let _ = positionInfo.addElement(element: elementRight)
        let _ = positionInfo.removeElement(element: elementRight)
        XCTAssertFalse(positionInfo.thereIsElementInSpace(element: elementRight))
    }
    
    func testMovementPosition() {
        let positionInfo = PositionInfoManager(numberOfColumns: 4, frame: CGRect(x: 0, y: 0, width: 450, height: 750))
        let elementRight = Element(row: 0, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let elementRight2 = Element(row: 1, column: 0, squaresOfWidth: 1, squaresOfHeight: 1)
        let _ = positionInfo.addElement(element: elementRight2)
        let _ = positionInfo.addElement(element: elementRight)
        
        XCTAssertNotNil(positionInfo.movePosition(element: elementRight, point: CGPoint(x: 300, y: 400)))
    }
    
}
