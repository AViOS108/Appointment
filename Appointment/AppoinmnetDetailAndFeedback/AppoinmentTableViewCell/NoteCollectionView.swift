//
//  NoteCollectionView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 23/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit




class NoteCollectionView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate {

    var viewController : UIViewController!
    var noteModalObj :   NotesModal?

    var mynotes : Bool?
    
    var isNotes = false
    
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
        
        if noteModalObj?.results?.count == 0{
            isNotes = true
        }
        else{
            isNotes = false
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
        if isNotes{
            return 1
        }
        
        if noteModalObj?.isExpandableNotes ?? true{
            return noteModalObj?.results?.count ?? 0
        }
        else{
            
            return 1
            
        }
        
        
        
     }
     
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCollectionViewCell", for: indexPath as IndexPath) as! NoteCollectionViewCell
        
        cell.delegate = viewController as! NoteCollectionViewCellDelegate

        cell.mynotes = self.mynotes;
        if isNotes{
             cell.customization(noNotes: isNotes)
        }
        else{
            cell.noteResultModal = self.noteModalObj?.results?[indexPath.row];
                  cell.customization(noNotes: isNotes)
        }
      
       return cell
     }
     
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
   
    

    
    
   
}


extension NoteCollectionView: NotesCollectionViewlayoutDelegate {
    
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
    
    if self.noteModalObj?.results?.count ?? 0 > 0{
        label.text = self.noteModalObj?.results?[indexPath.row].data

    }
    else
    {
        label.text = "TEXT WHICH IS USED TO INCREASE THE HEIGHT OF CELL"

    }
    
    //    label.attributedText = attributedText
    label.sizeToFit()
    return label.frame.height + 80 //(Please change it if u have changed the constraint of uicolllection cell)
    //    return label.frame.height
    
    }
}
