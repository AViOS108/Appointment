//
//  ERStudentOverlayView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 31/03/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit




class ERStudentOverlayView:UIView, UICollectionViewDataSource,UICollectionViewDelegate, ERStudentCollectionViewLayoutDelegate {
   
    func collectionViewReload(width: Int)  {
        viewcontrollerI.nslayputCollectionViewWidth.constant = CGFloat(width)
        viewCollection.frame.size.width = CGFloat(width)
        viewCollection.layoutIfNeeded()
    }
    
    var viewcontrollerI : ERSideMyAppoinmentTableViewCell!
    var viewCollection : UICollectionView!
    func customize()
    {
        
        if
            (viewcontrollerI.results.requests?.count ?? 0) == 0{
            return;
        }
        
        
        viewCollection.dataSource = self
        viewCollection.delegate = self
        viewCollection.reloadData()
    
        if let layout = viewCollection?.collectionViewLayout as? ERStudentCollectionViewLayout {
          layout.delegate = self
            layout.contentWidth = 0
            layout.cache = []
        }
        viewCollection.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewcontrollerI.results.requests?.count ?? 0)
     }
     
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        viewCollection.register(UINib.init(nibName: "ERStudentOverlayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ERStudentOverlayCollectionViewCell")
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ERStudentOverlayCollectionViewCell", for: indexPath as IndexPath) as! ERStudentOverlayCollectionViewCell
        cell.studentModal =  viewcontrollerI.results.requests? [indexPath.row].studentDetails
        cell.customize(viewCollectinView: self.viewCollection)
       return cell
     }
     
  
   
}

