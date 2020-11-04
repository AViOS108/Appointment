//
//  NoteCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 23/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol NoteCollectionViewCellDelegate {
    
    func editDeleteFunctionality(objModel : NotesResult?,isMyNotes: Bool?,isDeleted:Bool )
    
}


class NoteCollectionViewCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    @IBOutlet weak var viewEditContainer: UIView!
    
    @IBOutlet weak var viewSeprator: UIView!
    @IBOutlet weak var viewEdit: UIView!
    var mynotes : Bool?

    var delegate : NoteCollectionViewCellDelegate!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnEditDelete: UIButton!
   
    @IBAction func btnDeleteTappped(_ sender: Any) {
        
//        if !(mynotes ?? true){
//
//                   self.btnEditDelete.isEnabled = false
//                   self.btnEditDelete.isUserInteractionEnabled = false
//
//
//               }
        
        
        
        self.viewEditContainer.isHidden = true
        delegate.editDeleteFunctionality(objModel: noteResultModal, isMyNotes: mynotes, isDeleted: true)
        
        
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
         self.viewEditContainer.isHidden = true
        delegate.editDeleteFunctionality(objModel: noteResultModal, isMyNotes: mynotes, isDeleted: false)

        
    }
    
    
    
    
    @IBOutlet weak var lblNoNotes: UILabel!
    
    @IBAction func btnEditDeleteTapped(_ sender: Any) {
        self.viewEditContainer.isHidden = false
    }
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblNotesTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var noteResultModal: NotesResult?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customization(noNotes: Bool) {
        
        if noNotes{
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            UILabel.labelUIHandling(label: lblNoNotes, text: "No Notes Found !!!", textColor: ILColor.color(index: 39), isBold: false, fontType: fontBook)
            viewContainer.isHidden = true
            viewEditContainer.isHidden = true
            lblNoNotes.isHidden = false

        }
        else{
            viewContainer.isHidden = false
            btnEditDelete.setImage(UIImage.init(named: "more_vert"), for: .normal)
            lblNoNotes.isHidden = true
            let weekDay = ["Sun","Mon","Tues","Wed","Thu","Fri","Sat"]
            let componentDay = GeneralUtility.dateComponent(date: self.noteResultModal?.createdAt ?? "", component: .weekday)
            let date = GeneralUtility.currentDateDetailType4(emiDate: self.noteResultModal?.createdAt ?? "");
            let timeText = "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " + date;
            let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14)
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            UILabel.labelUIHandling(label: lblNotesTime, text: timeText, textColor: ILColor.color(index: 38), isBold: false, fontType: fontMedium)
            UILabel.labelUIHandling(label: lblDescription, text: noteResultModal?.data ?? "", textColor: ILColor.color(index: 39), isBold: false, fontType: fontBook)
            
            self.viewEditContainer.tag = 19682
            tapGesture()
            self.viewEditContainer.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.viewEditContainer.isHidden = true
            
            btnEdit.isUserInteractionEnabled = true
            btnEdit.isEnabled = true
            
            self.viewEdit.layer.zPosition = 10;
                        UIButton.buttonUIHandling(button: btnEdit, text: "Edit", backgroundColor: .clear, textColor: ILColor.color(index:36),fontType: fontBook)
            
            btnDelete.isUserInteractionEnabled = true
            btnDelete.isEnabled = true
            
            UIButton.buttonUIHandling(button: btnDelete, text: "Delete", backgroundColor: .clear, textColor: ILColor.color(index:36),fontType: fontBook)
            viewSeprator.backgroundColor = ILColor.color(index: 27)
            self.viewEdit.dropShadowER()
            
        }
        
        if !(mynotes ?? true){
         
            self.btnEditDelete.isEnabled = false
            self.btnEditDelete.isUserInteractionEnabled = false
            
            
        }
        
        
        
    }
    
    
   
      
      func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
          if touch.view?.isDescendant(of: self) == true  && touch.view?.tag != 19682  {
              return false
          }
          return true
      }
      
      func tapGesture()  {
          let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
          tap.delegate = self
          self.viewEditContainer.isUserInteractionEnabled = true
         self.viewEditContainer.addGestureRecognizer(tap)
      }
      
      @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.viewEditContainer.isHidden = true
      }
    
    
}
