//
//  ERSideFIrstTypeCollectionView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 01/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERSideFIrstTypeCollectionViewDelegate {
    func acceptDeclineApi(isAccept : Bool, selectedRow : Int)
    func sendEmail(email :String)

}


class ERSideFIrstTypeCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var appoinmentDetailAllModalObj: ApooinmentDetailAllNewModal?
    var delegateI : ERSideFIrstTypeCollectionViewDelegate!
    var viewController : UIViewController!
    var selectedfragmentNumber = 1;

    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    func customize()
    {
        self.layoutIfNeeded()
        self.collectionViewLayout = ERAppoDetailFirstCollectionViewLayout()
        self.dataSource = self
        self.delegate = self
        
        if let layout = self.collectionViewLayout as? ERAppoDetailFirstCollectionViewLayout {
            layout.cache = []
            layout.contentHeight = 0
            layout.contentWidth = 0
            layout.delegate = self
        }
        self.isPagingEnabled = true
        self.bounces = false
        self.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return appoinmentDetailAllModalObj?.appoinmentDetailModalObj?.requests?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ERSideAppoDetailTypeFirstCollectionViewCell", for: indexPath as IndexPath) as! ERSideAppoDetailTypeFirstCollectionViewCell
        
        cell.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj
        cell.index = self.appoinmentDetailAllModalObj?.status ?? 2
        cell.selectedfragmentNumber = selectedfragmentNumber
        cell.indexPathRow = indexPath.row
        cell.delegate = self
        cell.customization();
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
}

extension ERSideFIrstTypeCollectionView :ERAppoDetailFirstCollectionViewLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, width: CGFloat, heightForCellAtIndexpath indexPath: IndexPath) -> CGFloat {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (viewController.view.frame.width - 48), height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        label.font = fontBook
        
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: (viewController.view.frame.width - 48), height: CGFloat.greatestFiniteMagnitude))
        label1.numberOfLines = 0
        label1.font = fontBook
        
        
        let cell : ERSideAppoDetailTypeFirstCollectionViewCell = ERSideAppoDetailTypeFirstCollectionViewCell()
        cell.indexPathRow = indexPath.row
        cell.requestDetail = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj?.requests![indexPath.row]
        cell.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj

        label.attributedText = cell.descriptionLogic()
        label1.attributedText = cell.nameLogic()
        label.sizeToFit()
        label1.sizeToFit()
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            return label.frame.height + label1.frame.height
        }
        else
        {
            return 285.0
        }
        
      
    }
    
    func widthCell() -> CGFloat {
        return  (viewController.view.frame.width - 16)
    }
    
}

extension ERSideFIrstTypeCollectionView : ERSideAppoDetailTypeFirstCollectionViewCellDelegate {
    
    func sendEmail(email :String)
    {
        delegateI.sendEmail(email: email)
    }
    
    func acceptDeclineApi(isAccept: Bool, selectedRow : Int) {
        delegateI.acceptDeclineApi(isAccept: isAccept, selectedRow : selectedRow)
    }
    func moveCollectionView(backward: Bool) {
        if backward {
             selectedfragmentNumber = selectedfragmentNumber - 1;

            self.scrollToPreviousItem()
        }
        else{
            selectedfragmentNumber = selectedfragmentNumber + 1;

            self.scrollToNextItem()
        }
    }
}
