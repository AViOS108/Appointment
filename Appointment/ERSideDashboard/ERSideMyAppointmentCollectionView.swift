//
//  ERSideMyAppointmentCollectionView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 20/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


struct ERSideMyAppointmentCVModal {
   
    var title : String!
    var id : Int!
    var isSelected : Bool!


}

protocol ERSideMyAppointmentCollectionViewDelegate {
    func selectedHeaderCV(id: Int)
}


class ERSideMyAppointmentCollectionView: UICollectionView ,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,ERSideMyAppointmentHeaderCollectionViewCelDelegate {
   
    
    func selectedHeaderCVCell(id: Int) {
        
        delegateI.selectedHeaderCV(id: id)
        
        var arrModalI = [ERSideMyAppointmentCVModal]();
        for objModal  in self.arrmodal {
            var objModalI = objModal
            if objModal.id == id {
                objModalI.isSelected = true
            }
            else{
                objModalI.isSelected = false
            }
            arrModalI.append(objModalI)
        }
        self.arrmodal.removeAll()
        self.arrmodal.append(contentsOf: arrModalI)
        
        self.reloadData();
        
        
        
    }
    
    
    var delegateI : ERSideMyAppointmentCollectionViewDelegate!
    var viewControllerI : UIViewController!
    var arrmodal = [ERSideMyAppointmentCVModal]();
    func collectionViewModal(title : String, id : Int)-> ERSideMyAppointmentCVModal{
        
        var objERSideMyAppointmentCVModal = ERSideMyAppointmentCVModal();
        objERSideMyAppointmentCVModal.title = title;
        objERSideMyAppointmentCVModal.id = id;
        if id == 1{
            objERSideMyAppointmentCVModal.isSelected = true
        }
        else{
            objERSideMyAppointmentCVModal.isSelected = false

        }

        return objERSideMyAppointmentCVModal
    }
    
    func customize(date:Date = Date())
    {
        
        arrmodal.append(self.collectionViewModal(title: "Upcoming", id: 1))
        arrmodal.append(self.collectionViewModal(title: "Pending Requests", id: 2))
        arrmodal.append(self.collectionViewModal(title: "Past", id: 3))

        
        self.register(UINib.init(nibName: "ERSideMyAppointmentHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ERSideMyAppointmentHeaderCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        self.layoutIfNeeded();
        self.reloadData()
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.frame.size.width/3, height: 55)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrmodal.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ERSideMyAppointmentHeaderCollectionViewCell", for: indexPath as IndexPath) as! ERSideMyAppointmentHeaderCollectionViewCell
        cell.objERSideMyAppointmentCVModal = self.arrmodal[indexPath.row];
        cell.delegate = self
        cell.customize()
         return cell
        
    }
    
    
   
    
    
   
    
}
