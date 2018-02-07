//
//  GridView.swift
//  SuperCustomCollection
//
//  Created by Leonardo Geus on 22/12/2017.
//  Copyright © 2017 Leonardo Geus. All rights reserved.
//

import UIKit

public protocol GridLayoutDelegate: class {
    func getCellsSupport(gridView:GridView) -> [CellSupport]
}

public class GridView: UICollectionView,GridInternalLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    ///////////////////////////////////////////////////////////////
    // Variables //
    ///////////////////////////////////////////////////////////////
    
    internal var columns = 0
    internal var rows = 0
    var cellWidth:CGFloat = 0.0
    var elements = [CellSupport]()
    internal var positionInfo:PositionInfoManager!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    public weak var gridDelegate: GridLayoutDelegate!
    internal var movingCell:CellSupport!
    internal var snapShotView = UIView()
    
    var DEBUG = false
    
    internal var tapGesture:UITapGestureRecognizer!
    
    public var tapToResize:Bool {
        get {
            if let _ = tapGesture {
                return true
            } else {
                return false
            }
        }
        set(status) {
            if status {
                tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
                tapGesture.numberOfTapsRequired = 2
                self.addGestureRecognizer(tapGesture)
            } else {
                if let _ = tapGesture {
                    self.removeGestureRecognizer(tapGesture)
                }
            }
        }
        
    }
    
    public var longPressToMove:Bool {
        get {
            if let _ = longPressGesture {
                return true
            } else {
                return false
            }
        }
        set(status) {
            if status {
                longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
                self.addGestureRecognizer(longPressGesture)
            } else {
                if let _ = longPressGesture {
                    self.removeGestureRecognizer(longPressGesture)
                }
            }
        }
        
    }
    
    public func getNumberOfCols() -> Int {
        if let _ = positionInfo {
            return positionInfo.numberOfColumns
        } else {
            _ = Error.get(code: .e102)
            return 0
        }
    }
    
    public func getNumberOfRows() -> Int {
        if let _ = positionInfo {
            return positionInfo.numberOfRows
        } else {
            _ = Error.get(code: .e101)
            return 0
        }
    }
    
    internal enum Orientation {
        case Horizontal
        case Vertical
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func lprint(_ s:String) {
        if DEBUG {
            print(s)
        }
    }
    
    func lprint(_ e:ErrorType) {
        _ = Error.get(code: e)
    }

    ///////////////////////////////////////////////////////////////
    // Collection View Delegate //
    ///////////////////////////////////////////////////////////////
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell
        cell?.addSubview(elements[indexPath.row].view)
        cell?.backgroundColor = elements[indexPath.row].view.backgroundColor
        return cell!
    }
    
    ///////////////////////////////////////////////////////////////
    // Data Manager //
    ///////////////////////////////////////////////////////////////
    
    var cellBuffer:[CellSupport]!
    
    internal func prepareCollection() {
        elements = gridDelegate.getCellsSupport(gridView: self)
        elements = positionInfo.addElementsOfSupportAndReturnApprovedCellsSupports(cellsSupport: elements)
    }
    
    public func reloadDataInGrid() {
        prepareCollection()
        self.reloadData()
    }
    
    internal func getPositionInfoManager(_ collectionView: UICollectionView) -> PositionInfoManager {
        return positionInfo
    }
    
    func reorderIndexOfArray() {
        let sortedElements = elements.sorted(by: { $0.index < $1.index })
        elements = sortedElements
    }
    
    ///////////////////////////////////////////////////////////////
    // Public Functions //
    ///////////////////////////////////////////////////////////////
    
    public func initialize(numberOfColumns:Int,debug:Bool,optionalPadding padding:CGFloat=0) {
        self.delegate = self
        self.dataSource = self
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        self.addGestureRecognizer(longPressGesture)
        
        let bundle = Bundle(for: GridLayout.self)
        self.register(UINib(nibName: "ColorCell", bundle: bundle), forCellWithReuseIdentifier: "colorCell")
        if debug {
            DEBUG = true
        } else {
            DEBUG = false
        }
        
        if let layout = self.collectionViewLayout as? GridLayout {
            layout.delegate = self
        }
        if let _ = positionInfo {
        } else {
            var rect = CGRect()
            if UIDevice.current.orientation.isLandscape {
                rect = updateFrameOfCollection(orientation: .Horizontal)
            } else {
                rect = updateFrameOfCollection(orientation: .Vertical)
            }
            positionInfo = PositionInfoManager(numberOfColumns: numberOfColumns, frame: rect, padding: padding)
            positionInfo.DEBUG = debug
            positionInfo.updateFrame(frame:rect)
            prepareCollection()
            
        }
    }
    
    ///////////////////////////////////////////////////////////////
    // Frame Manager //
    ///////////////////////////////////////////////////////////////
    
    public func viewWillTransition(size:CGSize) {
        DispatchQueue.main.async {
            var rect = CGRect()
            if size.width > size.height {
                rect = self.updateFrameOfCollection(orientation: .Horizontal)
            } else {
                rect = self.updateFrameOfCollection(orientation: .Vertical)
            }
            self.positionInfo.updateFrame(frame:rect)
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    func updateFrameOfCollection(orientation:Orientation) -> CGRect {
        var frameBack = self.frame
        if orientation == .Horizontal {
            let prop = self.frame.width/self.frame.height
            frameBack = CGRect(x: frameBack.minX, y: frameBack.minY, width: self.frame.width, height: self.frame.width*prop)
        }
        if let layout = self.collectionViewLayout as? GridLayout {
            layout.frameSize = frameBack
        }
        return frameBack
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    ///////////////////////////////////////////////////////////////
    // Gesture Manager //
    ///////////////////////////////////////////////////////////////
    
    @objc public func handleTap(tap: UITapGestureRecognizer)
    {
        if (UIGestureRecognizerState.ended == tap.state) {
            let collectionView = tap.view as! UICollectionView
            let point: CGPoint = tap.location(in: collectionView)
            let indexPath = collectionView.indexPathForItem(at: point)
            if let _ = indexPath {
                let supportCell = elements[(indexPath?.row)!]
                let element = supportCell.element!
                elements.remove(at: (indexPath?.row)!)
                if let newElement = positionInfo.resizeCell(element: element, newHeight: element.squaresOfHeight+1, newWidth: element.squaresOfWidth+1) {
                    let newCellSupport = CellSupport(cellSupport: supportCell, element: newElement)
                    elements.append(newCellSupport)
                } else {
                    if supportCell.element.squaresOfHeight > 1 {
                        if let newElement = positionInfo.resizeCell(element: supportCell.element, newHeight: supportCell.element.squaresOfHeight-1, newWidth: supportCell.element.squaresOfWidth-1) {
                            let newCellSupport = CellSupport(cellSupport: supportCell, element: newElement)
                            elements.append(newCellSupport)
                            
                        } else {
                            elements.append(supportCell)
                        }
                    } else {
                        elements.append(supportCell)
                    }
                }
                collectionView.reloadData()
            }
        }
    }

    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = self.indexPathForItem(at: gesture.location(in: self)) else {
                break
            }
            let cell = self.cellForItem(at: selectedIndexPath) as! ColorCollectionViewCell!
            snapShotView  = snapshopOfCell(inputView: cell!)
            
            var center = cell!.center
            snapShotView.center = center
            snapShotView.alpha = 0.0
            self.addSubview(snapShotView)
            let position = gesture.location(in: gesture.view!)
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                center.y = position.y
                center.x = position.x
                self.snapShotView.center = center
                self.snapShotView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.snapShotView.alpha = 0.98
            }, completion: { (finished) -> Void in
                
            })
            
            
            movingCell = elements[selectedIndexPath.row]
            var indexToRemove = -1
            for i in 0...elements.count-1 {
                if elements[i] == movingCell {
                    indexToRemove = i
                    break
                }
            }
            elements.remove(at: indexToRemove)
            if positionInfo.removeElement(element: movingCell.element) {
                lprint("Removed item with sucess")
            } else {
                lprint(.e103)
            }
            
            
            self.reloadData()
            if DEBUG {
                positionInfo.plotMatrix()
            }
            break
        case .changed:
            if let _ = movingCell {
                let position = gesture.location(in: gesture.view!)
                var center = snapShotView.center
                center.y = position.y
                center.x = position.x
                snapShotView.center = center
            }
            break
        case .ended:
            if let _ = movingCell {
                let position = gesture.location(in: gesture.view!)
                if positionInfo.testMovementPosition(element: movingCell.element, point: position) {
                    if let newElement = positionInfo.movePosition(element: movingCell.element, point: position) {
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            let center = self.positionInfo.getCenterOfElement(element:newElement)
                            self.snapShotView.center = center
                            self.snapShotView.transform = .identity
                            self.snapShotView.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                self.snapShotView.removeFromSuperview()
                                self.snapShotView = UIView()
                            }
                        })
                        elements.append(CellSupport(cellSupport: movingCell, element: newElement))
                    }
                } else {
                    if positionInfo.addElement(element: movingCell.element) {
                        elements.append(movingCell)
                        lprint("Item was moved with sucess")
                    } else {
                        lprint(.e104)
                    }
                }
                self.reloadData()
                snapShotView.removeFromSuperview()
                movingCell = nil
            }
            break
        default:
            break
        }
    }
}

class ColorCollectionViewCell: UICollectionViewCell {
}
