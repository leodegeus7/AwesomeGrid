//
//  ViewController.swift
//  DemoApp
//
//  Created by Leonardo Geus on 26/12/2017.
//  Copyright © 2017 Leonardo Geus. All rights reserved.
//

import UIKit
import GridLayout

class ViewController: UIViewController,GridLayoutDelegate {

    @IBOutlet weak var collectionView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.gridDelegate = self
        collectionView.inicialize(numberOfColumns: 4, optionalPadding: 5)
        collectionView.backgroundColor = UIColor.white
        collectionView.tapToResize = false
    }
    
    //let colors:[UIColor] = [UIColor.red,UIColor.blue,UIColor.orange,UIColor.green,UIColor.brown,UIColor.yellow,UIColor.magenta,UIColor.purple,UIColor.cyan,UIColor.green]
    
    
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
    
    func getCellsSupport() -> [CellSupport] {
        
        var cells = [CellSupport]()
        
        let cell1 = CellSupport(gridView: collectionView, row: 0, column: 0, squaresOfHeight: 1, squaresOfWidth: 4)
        cells.append(cell1)
        let cell3 = CellSupport(gridView: collectionView, row: 1, column: 0, squaresOfHeight: 2, squaresOfWidth: 2)
        cells.append(cell3)
        let cell4 = CellSupport(gridView: collectionView, row: 1, column: 2, squaresOfHeight: 1, squaresOfWidth: 1)
        cells.append(cell4)
        let cell5 = CellSupport(gridView: collectionView, row: 1, column: 3, squaresOfHeight: 1, squaresOfWidth: 1)
        cells.append(cell5)
        let cell6 = CellSupport(gridView: collectionView, row: 2, column: 2, squaresOfHeight: 1, squaresOfWidth: 2)
        cells.append(cell6)
        let cell7 = CellSupport(gridView: collectionView, row: 3, column: 0, squaresOfHeight: 1, squaresOfWidth: 1)
        
        cells.append(cell7)
        let cell8 = CellSupport(gridView: collectionView, row: 3, column: 1, squaresOfHeight: 1, squaresOfWidth: 1)
        cells.append(cell8)
        let cell9 = CellSupport(gridView: collectionView, row: 3, column: 2, squaresOfHeight: 1, squaresOfWidth: 1)
        cells.append(cell9)
        let cell10 = CellSupport(gridView: collectionView, row: 3, column: 3, squaresOfHeight: 1, squaresOfWidth: 1)
        cells.append(cell10)
        let cell11 = CellSupport(gridView: collectionView, row: 4, column: 0, squaresOfHeight: 2, squaresOfWidth: 4)
        cells.append(cell11)
        
        let cell12 = CellSupport(gridView: collectionView, row: 6, column: 0, squaresOfHeight: 1, squaresOfWidth: 1)
        cells.append(cell12)
        let cell13 = CellSupport(gridView: collectionView, row: 6, column: 1, squaresOfHeight: 1, squaresOfWidth: 1)
        cells.append(cell13)
        let cell14 = CellSupport(gridView: collectionView, row: 6, column: 2, squaresOfHeight: 1, squaresOfWidth: 1)
        cells.append(cell14)
        let cell15 = CellSupport(gridView: collectionView, row: 6, column: 3, squaresOfHeight: 1, squaresOfWidth: 1)
        cells.append(cell15)
        let cell16 = CellSupport(gridView: collectionView, row: 6, column: 0, squaresOfHeight: 2, squaresOfWidth: 4)
        cells.append(cell16)

        
        var count = 0
        for cell in cells {
            cell.view.backgroundColor = colors[count]
            count = count + 1
            if count >= colors.count {
                count = 0
            }
        }
        
        return cells
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.viewWillTransition(size: size)
    }
}

