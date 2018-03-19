//
//  DataSingleton.swift
//  DemoApp
//
//  Created by Leonardo Geus on 08/02/2018.
//  Copyright © 2018 Leonardo Geus. All rights reserved.
//

import UIKit
import GridLayout

class DataSingleton: NSObject {
    static let shared = DataSingleton()
    
    var dragItem:CellSupport!
    var dragSnapShot:UIImage!
}
