//
//  CoachImageOverlayView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 28/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol CoachImageOverlayViewDelegate {
    
    func selectedDifferentCoach(coach: Item?)
    
}


class CoachImageOverlayView: UIView, UICollectionViewDataSource,UICollectionViewDelegate,CoachImageOverlayLayoutDelegate {
   
    func collectionViewReload(width: Int)  {
        viewCollection.frame.size.width = CGFloat(width)
        viewCollection.layoutIfNeeded()
    }
    
    var viewcontrollerI : CoachSelectionViewController!
    var viewCollection : UICollectionView!
    var delegate : CoachImageOverlayViewDelegate?
    func customize()
    {
        
//        if viewcontrollerI.selectedDataFeedingModal?.items.count == 0{
//            return;
//        }
//        
        
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
            layout.numberOfColumns = (viewcontrollerI.selectedDataFeedingModal?.items.count  as? Int ?? 0 ) + 1
        }
        viewCollection.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = viewcontrollerI.selectedDataFeedingModal?.items.count {
            
            return count + 1
        }
        else {
            return 0
        }
        
     }
     
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        viewCollection.register(UINib.init(nibName: "CoachImageOverlayCiCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CoachImageOverlayCiCollectionViewCell")
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoachImageOverlayCiCollectionViewCell", for: indexPath as IndexPath) as! CoachImageOverlayCiCollectionViewCell
        if indexPath.row == viewcontrollerI.selectedDataFeedingModal?.items.count{
            cell.customize(viewCollectinView: self.viewCollection, isnewAdded: true)

        }
        else{
            cell.coachModal = viewcontrollerI.selectedDataFeedingModal?.items[indexPath.row]
            cell.customize(viewCollectinView: self.viewCollection, isnewAdded: false)

        }
       return cell
     }
     
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == viewcontrollerI.selectedDataFeedingModal?.items.count{
            delegate?.selectedDifferentCoach(coach: nil)
        }
        else
        {
            if collectionView.tag != 9876{
                delegate?.selectedDifferentCoach(coach: (viewcontrollerI.selectedDataFeedingModal?.items[indexPath.row])!)
            }
        }
       
        
    }
   
}

