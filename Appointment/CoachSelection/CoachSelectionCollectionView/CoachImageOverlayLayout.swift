//
//  CoachImageOverlayLayout.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 28/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol CoachImageOverlayLayoutDelegate: AnyObject {
    func collectionViewReload(width: Int)
    
    
}

class CoachImageOverlayLayout: UICollectionViewLayout {

    
    weak var delegate: CoachImageOverlayLayoutDelegate?

    
    private let numberOfColumns = 4

    // 3
    var cache: [UICollectionViewLayoutAttributes] = []

    // 4
    private var contentHeight: CGFloat {
      guard let collectionView = collectionView else {
        return 0
      }
      let insets = collectionView.contentInset
      return collectionView.bounds.height - (insets.left + insets.right)
    }

     var contentWidth : CGFloat = 0

    // 5
    override var collectionViewContentSize: CGSize {
      if (collectionView?.frame.size.height)! < contentHeight
      {
      }
      else
      {
        collectionView?.frame.size.height = contentHeight
        collectionView?.frame.size.width = contentWidth
        delegate?.collectionViewReload(width: Int(contentWidth))


      }
      return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
       // 1
       guard
         cache.isEmpty,
         let collectionView = collectionView
         else {
           return
       }
       // 2
        let columnWidth = 52.0
       var xOffset: [CGFloat] = []
       for column in 0..<numberOfColumns {
        xOffset.append(CGFloat(column) * (0.5 * CGFloat(columnWidth))  )
       }
       var column = 0
       var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
       // 3
         var  index = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            // 4
            let photoHeight = 44
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: CGFloat(columnWidth),
                               height: CGFloat(photoHeight))
            //         let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            attributes.zIndex = index
            cache.append(attributes)
            // 6
            index = index + 2

            contentWidth = max(contentWidth, frame.maxX)
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
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
