//
//  Error.swift
//  GridLayout
//
//  Created by Leonardo Geus on 27/12/2017.
//  Copyright © 2017 Leonardo Geus. All rights reserved.
//

import UIKit

enum ErrorType:String {
    case e101 = "Problem to find Position Info Object - number of rows invalid"
    case e102 = "Problem to find Position Info Object - number of cols invalid"
    case e103 = "Problem to delete item in Grid cell movement"
    case e104 = "Problem to move Item in Grid Layout"
    case e105 = "Not possible to add element"
    case e106 = "Not possible to add element, space is occupied: "
    case e107 = "Not possible to add element:: "
    case e108 = "Not added element"
    case e109 = "Element to remove not founded"
    case e110 = "Not possible to add element when resizing"
    case e111 = "Not possible to add element when resizing."
    case e112 = "Not possible to add element in update of CellSupport"
}

class Error:NSObject {

    static func get(code:ErrorType) -> String {
        print("\(code.rawValue) Error: \(code)")
        return code.rawValue
    }
}
