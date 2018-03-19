//
//  PositionInfo.swift
//  SuperCustomCollection
//
//  Created by Leonardo Geus on 13/12/2017.
//  Copyright © 2017 Leonardo Geus. All rights reserved.
//

import UIKit


class PositionInfoManager: NSObject {
    
    var numberOfColumns = 0
    var numberOfRows = 0
    var columnSize:CGFloat = 0.0
    var indexForCells = 0
    var DEBUG = false
    
    
    public var properlySeatedElements = [Element]()
    
    internal var frame = CGRect()
    internal var padding = CGFloat()
    internal var matrix = [[TypeObject]]()

    internal enum TypeObject:Int {
        case O = 0
        case X = 1
        case E = -1
    }

    public func getIndexForCreateCell() -> Int {
        indexForCells = indexForCells + 1
        return indexForCells - 1
    }
    
    public func updateFrame(frame:CGRect) {
        self.frame = frame
        columnSize = getColumnSize()
    }
    
    public func getNumberOfItens() -> Int {
        return properlySeatedElements.count
    }
    
    required init(numberOfColumns:Int,frame:CGRect,padding:CGFloat) {
        super.init()
        self.numberOfColumns = numberOfColumns
        self.frame = frame
        self.padding = padding
        self.matrix = createZeroMatrix()
    }
    
    internal func getColumnSize() -> CGFloat {
        return CGFloat(Float(frame.width) - Float((numberOfColumns-1))*Float(padding))/CGFloat(numberOfColumns)
    }
    
    internal func createZeroMatrix() -> [[TypeObject]] {
        var matrix = [[TypeObject]]()
        var totalHeight = frame.height
        columnSize = getColumnSize()
        numberOfRows = Int(totalHeight/columnSize)
        if padding > 0 {
            totalHeight = frame.height - padding * CGFloat(numberOfRows-1)
            numberOfRows = Int(totalHeight/columnSize)
        }
        let columns = numberOfColumns
        let rows = numberOfRows
        
        for _ in 0...rows-1 {
            var colArray = [TypeObject]()
            for _ in 0...columns-1 {
                colArray.append(.O)
            }
            matrix.append(colArray)
        }
        return matrix
    }
    
    
    public func getElementsInfo() -> [CGRect] {
        var sortedElements = properlySeatedElements.sorted(by: { $0.column < $1.column })
        sortedElements = sortedElements.sorted(by: { $0.row < $1.row })
        var resultArray = [CGRect]()
        for element in properlySeatedElements {
            var height:CGFloat = 0.0
            var width:CGFloat = 0.0
            var x:CGFloat = 0.0
            var y:CGFloat = 0.0
            
            if element.squaresOfHeight == 1 {
                height = CGFloat(element.squaresOfHeight) * columnSize
            } else {
                height = CGFloat(element.squaresOfHeight) * columnSize + CGFloat(element.squaresOfHeight - 1)*padding
            }
            
            if element.squaresOfWidth == 1 {
                width = CGFloat(element.squaresOfWidth) * columnSize
            } else {
                width = CGFloat(element.squaresOfWidth) * columnSize + CGFloat(element.squaresOfWidth - 1)*padding
            }
            
            x = CGFloat(element.column) * columnSize + padding*CGFloat(element.column)
            y = CGFloat(element.row) * columnSize + padding*CGFloat(element.row)
            
            let rect = CGRect(x: x, y: y, width: width, height: height)
            resultArray.append(rect)
        }
        return resultArray
    }
    
    
    public func addElement(element:Element) -> Bool {
        if let newMatrix = addElementInMatrix(matrix: matrix, element: element) {
            self.matrix = newMatrix
            lprint("Element add with success")
            plotMatrix()
            properlySeatedElements.append(element)
            return true
        } else {
            lprint(.e105)
            return false
        }
    }
    
    public func addElementsOfSupportAndReturnApprovedCellsSupports(cellsSupport:[CellSupport]) -> [CellSupport] {
        var approvedCellsSupports = [CellSupport]()
        for cell in cellsSupport {
            if let newMatrix = addElementInMatrix(matrix: matrix, element: cell.element) {
                self.matrix = newMatrix
                lprint("Element add with success")
                plotMatrix()
                properlySeatedElements.append(cell.element)
                approvedCellsSupports.append(cell)
            } else {
                lprint(.e106)
                lprint("\(cell.element!)")
            }
        }
        return approvedCellsSupports
    }
    
    public func updatePositionOfCellSupport(oldCellSupport:CellSupport,position:CGPoint) -> CellSupport? {
        let height = oldCellSupport.element.squaresOfHeight
        let width = oldCellSupport.element.squaresOfWidth
        let elementFake = Element(row: 0, column: 0, squaresOfWidth: width, squaresOfHeight: height)
        
        if testMovementPosition(element: elementFake, point: position) {
            if let newElement = movePosition(element: elementFake, point: position) {
                let newCellSupport = CellSupport(cellSupport: oldCellSupport, element: newElement)
                plotMatrix()
                return newCellSupport
            } else {
                lprint(.e107)
                lprint("\(elementFake)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    public func addElements(elements:[Element]) -> Bool {
        for element in elements {
            if let newMatrix = addElementInMatrix(matrix: matrix, element: element) {
                self.matrix = newMatrix
                lprint("Element add with success")
                plotMatrix()
                properlySeatedElements.append(element)
                
            } else {
                lprint(.e107)
                lprint("\(element)")
            }
        }
        return true
    }
    
    
    func getNumberOfPaddingsInPosition(yPoint:CGFloat) -> Int {
        var height:CGFloat = 0
        var paddings = 0
        while height < yPoint {
            height = height + columnSize + padding
            paddings = paddings + 1
        }
        return Int(paddings-1)
    }
    
    
    internal func getElementWithNewCoordinates(oldElement:Element,point:CGPoint) -> Element {
        var column = -1
        var row = -1
        var squaresOfHeight = -1
        var squaresOfWidth = -1
        
        let newYY = point.y - CGFloat(getNumberOfPaddingsInPosition(yPoint: point.y))*padding
        let newXX = point.x - CGFloat(getNumberOfPaddingsInPosition(yPoint: point.x))*padding
        
        row = Int(newYY/columnSize)
        column = Int(newXX/columnSize)
        squaresOfHeight = oldElement.squaresOfHeight
        squaresOfWidth = oldElement.squaresOfWidth
        return Element(row: row, column: column, squaresOfWidth: squaresOfWidth, squaresOfHeight: squaresOfHeight)
    }
    
    public func getCenterPositionOfFirstBlock(element:Element,centerPoint:CGPoint) -> CGPoint {
        let newX = centerPoint.x - columnSize/2*CGFloat(element.squaresOfWidth) + columnSize/2
        let newY = centerPoint.y - columnSize/2*CGFloat(element.squaresOfHeight) + columnSize/2
        return CGPoint(x: newX, y: newY)
    }
    
    public func testMovementPosition(element:Element,point:CGPoint) -> Bool {
        let newPoint = getCenterPositionOfFirstBlock(element: element, centerPoint: point)
        let newElement = getElementWithNewCoordinates(oldElement: element, point: newPoint)
        if elementFillInSpace(matrix: matrix, element: newElement) {
            if !thereIsElementInSpace(element: newElement) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    public func movePosition(element:Element,point:CGPoint) -> Element? {
        let newPoint = getCenterPositionOfFirstBlock(element: element, centerPoint: point)
        if testMovementPosition(element: element, point: point) {
            //let oldElement = element
            let newElement = getElementWithNewCoordinates(oldElement: element, point: newPoint)
            
            if addElement(element: newElement) {
                return newElement
            } else {
                lprint(.e107)
                return nil
            }
            
        } else {
            
            return nil
        }
    }
    
    public func getCenterOfElement(element:Element) -> CGPoint {
        let width = CGFloat(element.squaresOfWidth) * columnSize
        
        let x = CGFloat(element.column) * columnSize
        let y = CGFloat(element.row) * columnSize
        return CGPoint(x: x+width/2, y:y+width/2)
    }
    
    public func testIfElementFill(element:Element) -> Bool {
        if elementFillInSpace(matrix: matrix, element: element) {
            if !thereIsElementInSpace(element: element) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    public func removeElement(element:Element) -> Bool {
        var i = 0
        var indexToRemove = -1
        for ele in properlySeatedElements {
            if ele.column == element.column && ele.row == element.row && ele.squaresOfHeight == element.squaresOfHeight {
                indexToRemove = i
                break
            }
            i = i+1;
        }
        if indexToRemove != -1 {
            
            let elementToRemove = properlySeatedElements[indexToRemove]
            
            let row = elementToRemove.row
            let column = elementToRemove.column
            let height = elementToRemove.squaresOfHeight
            let width = elementToRemove.squaresOfWidth
            for y in row...(row+(height-1)) {
                for x in column...(column+(width-1)) {
                    matrix[y][x] = .O
                }
            }
            properlySeatedElements.remove(at: indexToRemove)
            return true
        } else {
            lprint(.e109)
            return false
        }
    }
    
    
    internal func addElementInMatrix(matrix:[[TypeObject]],element:Element) -> [[TypeObject]]? {
        if elementFillInSpace(matrix: matrix, element: element) {
            if !thereIsElementInSpace(element: element) {
                let column = element.column
                let row = element.row
                let height = element.squaresOfHeight
                let width = element.squaresOfWidth
                var newMatrix = matrix
                for y in row...(row+(height-1)) {
                    for x in column...(column+(width-1)) {
                        newMatrix[y][x] = .X
                    }
                }
                return newMatrix
            } else {
                let column = element.column
                let row = element.row
                let height = element.squaresOfHeight
                let width = element.squaresOfWidth
                var newMatrix = matrix
                for y in row...(row+(height-1)) {
                    for x in column...(column+(width-1)) {
                        if newMatrix[y][x] == .X {
                            newMatrix[y][x] = .E
                        } else {
                            newMatrix[y][x] = .O
                        }
                    }
                }
                return nil
            }
        } else {
            return nil
        }
    }
    
    internal func elementFillInSpace(matrix:[[TypeObject]],element:Element) -> Bool {
        let rows = matrix.count
        let columns = matrix.first!.count
        if element.row + element.squaresOfHeight <= rows {
            if element.column + element.squaresOfWidth <= columns {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    public func resizeCell(element:Element,newHeight:Int,newWidth:Int) -> Element? {
        let newElement = Element(row: element.row, column: element.column, squaresOfWidth: newWidth, squaresOfHeight: newHeight)
        if removeElement(element: element) {
            if elementFillInSpace(matrix: matrix, element: newElement) {
                if addElement(element: newElement) {
                    return newElement
                } else {
                    lprint(.e110)
                    let _ = addElement(element: element)
                    return nil
                }
            } else {
                let _ = addElement(element: element)
                return nil
            }
        } else {
            lprint(.e111)
            return nil
        }
    }
    
    internal func thereIsElementInSpace(element:Element) -> Bool {
        let column = element.column
        let row = element.row
        let height = element.squaresOfHeight
        let width = element.squaresOfWidth
        var newMatrix = matrix
        if newMatrix.count-1 < (row+(height-1)) {
            return false
        }

        for y in row...(row+(height-1)) {
            for x in column...(column+(width-1)) {
                if newMatrix[y].count-1 < (column+(width-1)) {
                    return false
                }
                if newMatrix[y][x] != .O {
                    return true
                }
            }
        }
        return false
    }
    
    public func plotMatrix() {
        lprint("")
        for col in self.matrix {
            var colString = ""
            for element in col {
                colString += "\(element.rawValue)"
                colString += " "
            }
            lprint(colString)
        }
    }
    
    func lprint(_ s:String) {
        if DEBUG {
            print(s)
        }
    }
    
    func lprint(_ e:ErrorType) {
        _ = Error.get(code: e)
    }
}

public struct Element {
    var row = 0
    var column = 0
    var squaresOfWidth = 0
    var squaresOfHeight = 0
}
