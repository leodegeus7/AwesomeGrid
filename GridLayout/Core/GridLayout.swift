//
//  GridLayout.swift
//  SuperCustomCollection
//
//  Created by Leonardo Geus on 12/12/2017.
//  Copyright © 2017 Leonardo Geus. All rights reserved.
//

import UIKit

protocol GridInternalLayoutDelegate: class {
    func getPositionInfoManager(_ collectionView:UICollectionView) -> PositionInfoManager
    
}

class GridLayout: UICollectionViewLayout {
    weak var delegate: GridInternalLayoutDelegate!
    fileprivate var numberOfColumns = 4
    fileprivate var numberOfRows = 0
    fileprivate var cellPadding: CGFloat = 0.0
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0
    
    var frameSize:CGRect!
    var positionInfo:PositionInfoManager!
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        if let _ = frameSize {
            return CGSize(width: frameSize.width, height: frameSize.height)
        } else {
            return (collectionView?.contentSize)!
        }
    }
    
    override func prepare() {
        cache = []
        guard let collectionView = collectionView else {
            return
        }
        if let _ = positionInfo {
        } else {
            positionInfo = delegate.getPositionInfoManager(collectionView)
        }
        let positionArray = positionInfo.getElementsInfo()
        let numberOfItens = positionInfo.getNumberOfItens()
        for item in 0 ..< numberOfItens {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = positionArray[item]
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
        }
        contentHeight = frameSize.height
    }
    
    override public func invalidateLayout() {
        cache.removeAll()
        super.invalidateLayout()
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let bounds = (self.collectionView?.bounds)!
        return ((newBounds.width != bounds.width ||
            (newBounds.height != bounds.height)))
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
