//
//  NotesCollectionViewlayout.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 24/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol NotesCollectionViewlayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,width : CGFloat,
        heightForCellAtIndexpath indexPath:IndexPath) -> CGFloat
    func widthCell() -> CGFloat;
}

class NotesCollectionViewlayout: UICollectionViewLayout {

       

    weak var delegate: NotesCollectionViewlayoutDelegate?
    private let numberOfColumns = 1

    // 3
    var cache: [UICollectionViewLayoutAttributes] = []

    // 4
     var contentHeight: CGFloat  = 0
     var contentWidth : CGFloat = 0
//     var contentWidth : CGFloat {
//
//       guard let collectionView = collectionView else {
//         return 0
//       }
//        print("adsdasd",collectionView.frame.size.width)
//        return collectionView.frame.size.width
//     }

    // 5
    override var collectionViewContentSize: CGSize {
//        collectionView?.frame.size.height = contentHeight
//        collectionView?.frame.size.width = contentWidth
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
        
        let xOffset: [CGFloat] = .init(repeating: 0, count: totalRows)
        contentWidth = delegate!.widthCell()
        var yOffset: [CGFloat] = .init(repeating: 0, count: totalRows)
        // 3
        for item in 0..<totalRows {
            let indexPath = IndexPath(item: item, section: 0)
            // 4
            let height = delegate?.collectionView(collectionView, width: delegate!.widthCell(), heightForCellAtIndexpath: indexPath)
//             height = 300

            
            let frame = CGRect(x: xOffset[item],
                               y: yOffset[item],
                               width: delegate!.widthCell(),
                               height: CGFloat(height ?? 0))
            let insetFrame = frame.insetBy(dx: 0, dy: 0)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            // 6
            if (item < (totalRows - 1)){
                
                yOffset[item + 1] = yOffset[item] + (height ?? 0)
            }
            contentHeight = contentHeight + (height ?? 0)
        }
//        collectionView.frame.size = CGSize.init(width: contentWidth, height: contentHeight)
//        
//        collectionView.contentSize = CGSize.init(width: contentWidth, height: contentHeight)

        
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
