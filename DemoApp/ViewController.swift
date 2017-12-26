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
        collectionView.gridDelegate = self
        collectionView.inicialize(numberOfColumns: 4)
        collectionView.tapToResize = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getCellsSupport() -> [CellSupport] {
        let cell1 = CellSupport(gridView: collectionView, x: 0, y: 0, squaresOfHeight: 1, squaresOfWidth: 3)
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view2.backgroundColor = UIColor.darkGray
        view2.center = cell1.view.center
        cell1.view.addSubview(view2)
        
        cell1.view.backgroundColor = UIColor.blue
        return [cell1]
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.viewWillTransition(size: size)
    }
    
}

