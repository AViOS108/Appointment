//
//  CoachImageOverlayView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 28/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class CoachImageOverlayView: UIView, UICollectionViewDataSource,UICollectionViewDelegate {

    
    var selectedDataFeedingModal : DashBoardModel?

    var viewCollection : UICollectionView!
    
    func customize()
    {
        
        viewCollection.dataSource = self
        viewCollection.delegate = self
        viewCollection.reloadData()
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (selectedDataFeedingModal?.coaches.count)!
     }
     
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        viewCollection.register(UINib.init(nibName: "CoachImageOverlayCiCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CoachImageOverlayCiCollectionViewCell")
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoachImageOverlayCiCollectionViewCell", for: indexPath as IndexPath) as! CoachImageOverlayCiCollectionViewCell
        cell.customize()
       return cell
     }
     
   

}
