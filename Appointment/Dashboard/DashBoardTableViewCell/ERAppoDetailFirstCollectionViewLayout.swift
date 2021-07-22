//
//  ERAppoDetailFirstCollectionViewLayout.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 02/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERAppoDetailFirstCollectionViewLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,width : CGFloat,
        heightForCellAtIndexpath indexPath:IndexPath) -> CGFloat
    func widthCell() -> CGFloat;
}

class ERAppoDetailFirstCollectionViewLayout: UICollectionViewLayout {

       

    weak var delegate: ERAppoDetailFirstCollectionViewLayoutDelegate?
    private let numberOfColumns = 1

    // 3
    var cache: [UICollectionViewLayoutAttributes] = []

    // 4
     var contentHeight: CGFloat  = 0
     var contentWidth : CGFloat = 0

    // 5
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        // 1
        guard
            cache.isEmpty,
            let collectionView = collectionView , let _ = delegate
            else {
                return
        }
        // 2
        let totalRows = collectionView.numberOfItems(inSection: 0)
        
        var xOffset: [CGFloat] = .init(repeating: 0, count: totalRows)
        contentWidth = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: totalRows)
        // 3
        for item in 0..<totalRows {
            let indexPath = IndexPath(item: item, section: 0)
            // 4
            var height = delegate?.collectionView(collectionView, width: delegate!.widthCell(), heightForCellAtIndexpath: indexPath)
//             height = 300
            let frame = CGRect(x: xOffset[item],
                               y: 0,
                               width: delegate!.widthCell(),
                               height: CGFloat(height ?? 0))
            let insetFrame = frame.insetBy(dx: 0, dy: 0)
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            // 6
            if (item < (totalRows - 1)){
                xOffset[item + 1] = xOffset[item] + (delegate!.widthCell() ?? 0)
            }
//            contentHeight = contentHeight + (height ?? 0)
            contentHeight = height ?? 0
            contentWidth = contentWidth + delegate!.widthCell()
        }
    }
     
     
     override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
            
            // Loop through the cache and look for items in the rect
            
            for attributes in cache {
                if attributes.frame.intersects(rect) {
                    //            attributes.zIndex = index
                    visibleLayoutAttributes.append(attributes)
                }
            }
            
            return visibleLayoutAttributes
            
           
    }
}