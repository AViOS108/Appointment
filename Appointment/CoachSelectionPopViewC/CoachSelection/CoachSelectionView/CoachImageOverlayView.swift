//
//  CoachImageOverlayView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 28/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol CoachImageOverlayViewDelegate {
    
    func selectedDifferentCoach(coach: Coach)
    
}


class CoachImageOverlayView: UIView, UICollectionViewDataSource,UICollectionViewDelegate,CoachImageOverlayLayoutDelegate {
   
    func collectionViewReload(width: Int)  {
        viewcontrollerI.nslayoutconstraintWidthCollection.constant = CGFloat(width)
        viewCollection.frame.size.width = CGFloat(width)
        viewCollection.layoutIfNeeded()
    }
    
    var viewcontrollerI : CoachSelectionViewController!
    var viewCollection : UICollectionView!
    var delegate : CoachImageOverlayViewDelegate?
    func customize()
    {
        
        if viewcontrollerI.selectedDataFeedingModal?.coaches.count == 0{
            return;
        }
        
        
        viewCollection.dataSource = self
        viewCollection.delegate = self
        viewCollection.reloadData()
    
        if let layout = viewCollection?.collectionViewLayout as? CoachImageOverlayLayout {
          layout.delegate = self
            layout.contentWidth = 0
            layout.cache = []
        }
        
        if let layout = viewCollection?.collectionViewLayout as? CoachHorizontalSelectionLayout {
            layout.contentWidth = 0
            layout.cache = []
            layout.numberOfColumns = viewcontrollerI.selectedDataFeedingModal?.coaches.count as! Int
        }
        viewCollection.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewcontrollerI.selectedDataFeedingModal?.coaches.count)!
     }
     
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        viewCollection.register(UINib.init(nibName: "CoachImageOverlayCiCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CoachImageOverlayCiCollectionViewCell")
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoachImageOverlayCiCollectionViewCell", for: indexPath as IndexPath) as! CoachImageOverlayCiCollectionViewCell
        cell.coachModal = viewcontrollerI.selectedDataFeedingModal?.coaches[indexPath.row]
        cell.customize(viewCollectinView: self.viewCollection)
       return cell
     }
     
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag != 9876{
            delegate?.selectedDifferentCoach(coach: (viewcontrollerI.selectedDataFeedingModal?.coaches[indexPath.row])!)
        }
        
    }
   
}

