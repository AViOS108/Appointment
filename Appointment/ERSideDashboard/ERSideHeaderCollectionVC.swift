//
//  ERSideHeaderCollectionVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ErSideCalenderCollectionViewCell"

protocol ERSideHeaderCollectionVCDelegate {
    
    func dateSelected(modalCalender: ERSideCalender)
    
}


class ERSideHeaderCollectionVC: UICollectionView,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,ErSideCalenderCollectionViewCellDelegate {
    
    var delegateI : ERSideHeaderCollectionVCDelegate!
    
    func datechanged(modalCalender: ERSideCalender) {
        selectedDate = modalCalender.dateC
        delegateI.dateSelected(modalCalender: modalCalender)
        var modelArr = [ERSideCalender]()
        for objERSideCalender in modalAray {
            
            var objERSideCalenderI = objERSideCalender
            
            let componentI = selectedDate.get(.day,.month,.year)
            let componentII = objERSideCalenderI.dateC.get(.day,.month,.year)

            
            if componentI.day == componentII.day && componentI.month == componentII.month && componentI.year == componentII.year{
                objERSideCalenderI.isSelected = true

            }else{
                objERSideCalenderI.isSelected = false
            }
            modelArr.append(objERSideCalenderI);
        }
        self.modalAray = modelArr
        
        self.reloadData()
        
    }
    
    
    
    var modalAray = [ERSideCalender]()
    var isWating : Bool!
    var selectedDate : Date!
    
    
    func customize(date:Date = Date())
    {
        self.register(UINib.init(nibName: "ErSideCalenderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ErSideCalenderCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        modalAray = self.createMonthModal(date: date)
        isWating = false
        self.reloadData()
        
        
    }
    
    
    func setCollectionOffest() {
        var index = 0
        for objERSideCalender in modalAray {
            
            if objERSideCalender.isSelected {
                break
            }
            index = index  + 1;
            
        }
        
        self.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally , animated: false)
        
    }
    
    
    
    
    func createMonthModal(date : Date) -> [ERSideCalender] {
        
        var modalAray = [ERSideCalender]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = Calendar.current.date(from: comp)!
        let numberOFDays = startOfMonth.get_Day()
        var index = 0
        while ( numberOFDays > index) {
            var calenderMo = ERSideCalender()
            var dateCompStartChange = DateComponents()
            dateCompStartChange.day = index;
            let dateI = Calendar.current.date(byAdding: dateCompStartChange, to: startOfMonth)!
            calenderMo.dateC = dateI
            
            let componentI = selectedDate.get(.day,.month,.year)
            let componentII = dateI.get(.day,.month,.year)
            
//            let componentIII = Date().get(.day,.month,.year)

            
            if dateI  >= Date() {
                calenderMo.isClickable = true
            }
            else{
                calenderMo.isClickable = false
            }
            
            
            if componentI.day == componentII.day && componentI.month == componentII.month && componentI.year == componentII.year{
                calenderMo.isSelected = true
                
            }else{
                calenderMo.isSelected = false
            }
            
            modalAray.append(calenderMo)
            index = index + 1;
        }
        return modalAray
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 50, height: 60)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return modalAray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErSideCalenderCollectionViewCell", for: indexPath as IndexPath) as! ErSideCalenderCollectionViewCell
        cell.delegate = self
        cell.modalCalender = self.modalAray[indexPath.row]
        cell.customize()
        
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if self.modalAray.count <= indexPath.row + 1  && !isWating {
            isWating = true
            
            self.updateNextSet(row: indexPath.row)
            
        }
        
    }
    
    
    func updateNextSet(row: Int){
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: self.modalAray[row].dateC)
        let startOfMonth = Calendar.current.date(from: comp)!
        var dateCompStartChange = DateComponents()
        dateCompStartChange.month = 1;
        let date = Calendar.current.date(byAdding: dateCompStartChange, to: startOfMonth)!
        
        modalAray.append(contentsOf: self.createMonthModal(date: date));
        isWating = false
        //requests another set of data (20 more items) from the server.
        DispatchQueue.main.async(execute: self.reloadData)
    }
    
    
}
