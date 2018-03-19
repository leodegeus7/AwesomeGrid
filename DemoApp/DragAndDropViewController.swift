//
//  DragAndDropViewController.swift
//  DemoApp
//
//  Created by Leonardo Geus on 07/02/2018.
//  Copyright © 2018 Leonardo Geus. All rights reserved.
//

import UIKit
import GridLayout

class DragAndDropViewController: UIViewController, GridLayoutDelegate,UICollectionViewDragDelegate,UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        
        let cell = collectionView.cellForItem(at: indexPath)
        let location = CGPoint(x: (cell?.frame.midX)!, y: (cell?.frame.midY)!)
        
        
        let dragItem = self.dragItem(forPhotoAt: location)
        
        return [dragItem]
    }
    

    
    
    private func dragItem(forPhotoAt location: CGPoint) -> UIDragItem {

        
        let item = gridView1.getCellIn(position: location)
        
        UIGraphicsBeginImageContextWithOptions(item.view.bounds.size, item.view.isOpaque, 0.0)
        item.view.drawHierarchy(in: item.view.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        DataSingleton.shared.dragItem = item
        DataSingleton.shared.dragSnapShot = snapshotImageFromMyView
        let itemProvider = NSItemProvider(object: snapshotImageFromMyView! as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item.index
        return dragItem
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let view = UIView(frame: collectionView.frame)
        let location = coordinator.session.location(in: view)
        
        coordinator.session.loadObjects(ofClass: UIImage.self) { items in
            
            guard let imgs = items as? [UIImage] else { return }
            

            for image in imgs {
                let data1 = UIImagePNGRepresentation(DataSingleton.shared.dragSnapShot)!
                let data2 = UIImagePNGRepresentation(image)!
                
                if data1 == data2 {
                    if let grid = collectionView as? GridView {
                        
                        grid.addOldCellSupportWithNewPosition(cellSupport: DataSingleton.shared.dragItem, position: location)
                    }
                }
                
            }
            DataSingleton.shared.dragItem = nil
            DataSingleton.shared.dragSnapShot = nil
        }
    }
    


    @IBOutlet weak var gridView1: GridView!
    @IBOutlet weak var gridView2: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gridView1.gridDelegate = self
        gridView2.gridDelegate = self

        gridView1.initialize(numberOfColumns: 4, debug: false)
        gridView2.initialize(numberOfColumns: 4, debug: true)

        gridView1.dragDelegate = self
        gridView1.dragInteractionEnabled = true
        gridView2.dropDelegate = self
    }

    func getCellsSupport(gridView: GridView) -> [CellSupport] {
        switch gridView {
        case gridView1:
            let cell1 = CellSupport(gridView: gridView1, row: 0, column: 0, squaresOfHeight: 1, squaresOfWidth: 1)
            cell1.view.backgroundColor = UIColor.cyan
            let cell2 = CellSupport(gridView: gridView1, row: 1, column: 1, squaresOfHeight: 1, squaresOfWidth: 1)
            cell2.view.backgroundColor = UIColor.red
            return [cell1,cell2]
        case gridView2:
            return []
        default:
            return []
        }
    }


}
