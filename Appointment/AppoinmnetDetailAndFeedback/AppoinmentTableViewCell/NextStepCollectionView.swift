//
//  NextStepCollectionView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 25/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//




import UIKit

class NextStepCollectionView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate {

    var viewController : UIViewController!
    var nextModalObj : [NextStepModal]?
    var isNoNextStep = false

    
    override func layoutSubviews() {
        super.layoutSubviews()
//        if bounds.size != intrinsicContentSize {
            
            self.invalidateIntrinsicContentSize()
            
//        }
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    
    func customize()
    {
        
        self.layoutIfNeeded()
        self.collectionViewLayout = NotesCollectionViewlayout()
        self.dataSource = self
        self.delegate = self
        
        if nextModalObj?.count == 0{
            isNoNextStep = true
        }
        
        
        
        if let layout = self.collectionViewLayout as? NotesCollectionViewlayout {
            layout.cache = []
            layout.contentHeight = 0
            layout.contentWidth = 0
            layout.delegate = self
        }
        
        self.reloadData()
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isNoNextStep{
            return 1
        }
        else{
            return nextModalObj?.count ?? 0
        }
       
     }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NextStepCollectionViewCell", for: indexPath as IndexPath) as! NextStepCollectionViewCell
        if isNoNextStep{
            cell.customization(isNextStep: isNoNextStep)
        }
        else{
            cell.nextModalObj = self.nextModalObj?[indexPath.row]
            cell.customization(isNextStep: isNoNextStep)
        }
        
        return cell
    }
     
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
   
    

    
    
   
}
extension NextStepCollectionView: NotesCollectionViewlayoutDelegate {
    
    func widthCell()->CGFloat{
        return  viewController.view.frame.width - 48
    }
    
    func collectionView(
        _ collectionView: UICollectionView,width : CGFloat,
        heightForCellAtIndexpath indexPath:IndexPath) -> CGFloat {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (viewController.view.frame.width - 48), height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        label.font = fontBook
        
        if self.nextModalObj?.count ?? 0 > 0{
            label.text = self.nextModalObj?[indexPath.row].data
        }
        else
        {
            label.text = "TEXT WHICH IS USED TO INCREASE THE HEIGHT OF CELL"
            
        }
        //    label.attributedText = attributedText
        label.sizeToFit()
        if self.nextModalObj?.count ?? 0 > 0{
            let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: (viewController.view.frame.width/2 - 48), height: CGFloat.greatestFiniteMagnitude))
            label1.numberOfLines = 0
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
            label1.font = fontHeavy
            if self.nextModalObj?.count ?? 0 > 0{
                label1.text = "Due Date:sdsdfdsd Mon, 15 jun 2020"
            }
            //    label.attributedText = attributedText
            label1.sizeToFit()
            return 60 + label1.frame.height + label.frame.height
        }
        
        else{
            return 60 +  label.frame.height
        }
          //    return label.frame.height
        
    }
}
