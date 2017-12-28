//
//  Colors.swift
//  DemoApp
//
//  Created by Leonardo Geus on 27/12/2017.
//  Copyright © 2017 Leonardo Geus. All rights reserved.
//

import UIKit

class Colors: NSObject {
    lazy var colors:[UIColor] = {
        return createColors((211,212,223),(118,101,170),(33,30,67),(254,197,21),(238,83,129),(142,186,210),(248,228,142))
    }()
    
    
    func transformColor(color:(Int,Int,Int)) -> UIColor {
        return  UIColor(red: CGFloat(color.0)/255, green: CGFloat(color.1)/255, blue: CGFloat(color.2)/255, alpha: 1)
    }
    
    func createColors(_ colors: (Int,Int,Int)...) -> [UIColor] {
        var transformedColors = [UIColor]()
        for color in colors {
            transformedColors.append(transformColor(color: color))
        }
        return transformedColors
    }
    
    var colorsCreated:[UIColor]!
    
    func getColors() -> [UIColor] {
        if let _ = colorsCreated {
            
        } else {
            colorsCreated = colors
        }
        return colorsCreated
    }
}
