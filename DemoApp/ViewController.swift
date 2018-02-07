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
        collectionView.initialize(numberOfColumns: 4, debug: true ,optionalPadding: 16)
        self.view.backgroundColor = UIColor.darkGray
        collectionView.longPressToMove = true
        collectionView.tapToResize = false
    }
    
    func getCellsSupport(gridView: GridView) -> [CellSupport] {
        var cells = [CellSupport]()
        let cell1 = CellSupport(gridView: collectionView, row: 0, column: 0, squaresOfHeight: 1, squaresOfWidth: 4)
        cells.append(cell1)
        cell1.view.backgroundColor = UIColor.red
        
        
        let cell2 = CellSupport(gridView: collectionView, row: 1, column: 0, squaresOfHeight: 2, squaresOfWidth: 2)
        cells.append(cell2)
        cell2.view.backgroundColor = UIColor.blue
        
        
        let cell3 = CellSupport(gridView: collectionView, row: 1, column: 2, squaresOfHeight: 2, squaresOfWidth: 2)
        cells.append(cell3)
        cell3.view.backgroundColor = UIColor.green
        
        let cell4 = CellSupport(gridView: collectionView, row: 3, column: 0, squaresOfHeight: 2, squaresOfWidth: 2)
        cells.append(cell4)
        cell4.view.backgroundColor = UIColor.green
        
        
        let cell5 = CellSupport(gridView: collectionView, row: 3, column: 2, squaresOfHeight: 2, squaresOfWidth: 2)
        cells.append(cell5)
        cell5.view.backgroundColor = UIColor.blue
        return cells
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.viewWillTransition(size: size)
    }
}

