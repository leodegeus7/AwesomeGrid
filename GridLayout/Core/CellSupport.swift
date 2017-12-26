//
//  CellSupport.swift
//  SuperCustomCollection
//
//  Created by Leonardo Geus on 14/12/2017.
//  Copyright © 2017 Leonardo Geus. All rights reserved.
//

import UIKit

public class CellSupport: NSObject {

    public var element:Element!
    public var view:UIView!
    var index:Int!
    
    public init(gridView:GridView,x:Int,y:Int,squaresOfHeight:Int,squaresOfWidth:Int) {
        super.init()
        let positionInfoManager = gridView.positionInfo
        element = Element(row: x, column: y, squaresOfWidth: squaresOfWidth, squaresOfHeight: squaresOfHeight)
        view = UIView(frame: CGRect(x: 0, y: 0, width: (positionInfoManager?.columnSize)!*CGFloat(squaresOfWidth), height: (positionInfoManager?.columnSize)!*CGFloat(squaresOfHeight)))
        index = positionInfoManager?.getIndexForCreateCell()
        
    }
    
    init(cellSupport:CellSupport,element:Element) {
        super.init()
        self.view = cellSupport.view
        self.element = element
        self.index = cellSupport.index
    }
}
