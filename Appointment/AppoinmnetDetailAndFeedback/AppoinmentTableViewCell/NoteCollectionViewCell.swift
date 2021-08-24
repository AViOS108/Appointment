//
//  NoteCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 23/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol NoteCollectionViewCellDelegate {
    
    func editDeleteFunctionality(objModel : NotesModalNewResult?,isDeleted:Bool )
    
}


class NoteCollectionViewCell: UICollectionViewCell,UIGestureRecognizerDelegate {
  
    var delegate : NoteCollectionViewCellDelegate!
    
    @IBOutlet weak var btnDelete: UIButton!

   
    @IBAction func btnDeleteTappped(_ sender: Any) {
        delegate.editDeleteFunctionality(objModel: noteResultModal, isDeleted: true)
        
        
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
        delegate.editDeleteFunctionality(objModel: noteResultModal,  isDeleted: false)

        
    }
    
    @IBOutlet weak var lblNoNotes: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblNotesTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var noteResultModal: NotesModalNewResult?
    
    var noteResultModalStudent: NotesResult?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    func shadowWithCorner(viewContainer : UIView,cornerRadius: CGFloat)
    {
        // corner radius
        viewContainer.layer.cornerRadius = cornerRadius
        // border
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.borderColor = ILColor.color(index: 27).cgColor
        // shadow
        viewContainer.layer.shadowColor = ILColor.color(index: 27).cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewContainer.layer.shadowOpacity = 0.7
        viewContainer.layer.shadowRadius = 4.0
        viewContainer.backgroundColor = .white
    }
    
    func customization(noNotes: Bool) {
        
        self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 10)

        if noNotes{
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            UILabel.labelUIHandling(label: lblNoNotes, text: "No Notes Found !!!", textColor: ILColor.color(index: 39), isBold: false, fontType: fontBook)
            viewContainer.isHidden = true
            lblNoNotes.isHidden = false

        }
        else{
            viewContainer.isHidden = false
            lblNoNotes.isHidden = true
            let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
            if isStudent ?? true {
                studentSidedateAndButtonLogic()
                lblDescription.attributedText =   studentSideDescription()
            }
            else
            {
                coachdateAndButtonLogic()
                lblDescription.attributedText =   coachSideDescription()
            }
        }
        
    }
    
    func sharedWIthLogic() -> String{
        
        var totalCount = 0;
        var name = ""
        for sharedwith in (self.noteResultModal?.entities)!{
            
            if sharedwith.canViewNote != "0"{
                  var displayName = ""
                if sharedwith.info?.name != nil{
                    displayName = sharedwith.info?.name ?? ""
                    }
                    else if sharedwith.info?.displayName != nil {
                        displayName = sharedwith.info?.displayName ?? ""
                    }
                if totalCount <= 2{
                    if name.isEmpty{
                        name = displayName
                    }
                    else{
                        name.append(",")
                        name.append(displayName)
                    }
                }
                
                totalCount = totalCount + 1;
            }
        }
        
        if totalCount > 2 {
            return name + " & + " + "\(totalCount - 2)" + " more";
        }
        else{
            return name
        }
        
        
    }
    
    
    func studentSidedateAndButtonLogic(){
        let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        let componentDay = GeneralUtility.dateComponent(date: self.noteResultModalStudent?.createdAt ?? "", component: .weekday)
        let date = GeneralUtility.currentDateDetailType4(emiDate: self.noteResultModalStudent?.createdAt ?? "", fromDateF: "yyyy-MM-dd HH:mm:ss", toDateFormate: "dd MMM yyyy")
        
        
        let timeText = "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " + date;
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        UILabel.labelUIHandling(label: lblNotesTime, text: timeText, textColor: ILColor.color(index: 38), isBold: false, fontType: fontHeavy)
        btnEdit.isUserInteractionEnabled = true
        btnEdit.isEnabled = true
        
        btnEdit.setImage(UIImage.init(named: "noun_edit_648236"), for: .normal)
        btnDelete.setImage(UIImage.init(named: "noun_Delete_2899273"), for: .normal)
        
        btnDelete.isUserInteractionEnabled = true
        btnDelete.isEnabled = true
    }
    
    
    func coachdateAndButtonLogic(){
        let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        let componentDay = GeneralUtility.dateComponent(date: self.noteResultModal?.createdAt ?? "", component: .weekday)
        let date = GeneralUtility.currentDateDetailType4(emiDate: self.noteResultModal?.createdAt ?? "", fromDateF: "yyyy-MM-dd HH:mm:ss", toDateFormate: "dd MMM yyyy")
        
        
        let timeText = "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " + date;
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        UILabel.labelUIHandling(label: lblNotesTime, text: timeText, textColor: ILColor.color(index: 38), isBold: false, fontType: fontHeavy)
        btnEdit.isUserInteractionEnabled = true
        btnEdit.isEnabled = true
        
        btnEdit.setImage(UIImage.init(named: "noun_edit_648236"), for: .normal)
        btnDelete.setImage(UIImage.init(named: "noun_Delete_2899273"), for: .normal)
        
        btnDelete.isUserInteractionEnabled = true
        btnDelete.isEnabled = true
    }
    
    func studentSideDescription() -> NSAttributedString{
        let strHeader = NSMutableAttributedString.init()
        if  let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE12), let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)
            
        {
            let strSharedWith = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Shared with : ", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:39),NSAttributedString.Key.font : fontMedium]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strSharedInfo = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "My notes", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 23),NSAttributedString.Key.font : fontMedium]);
           
         
            
            let data = Data((self.noteResultModalStudent?.data?.utf8)!)
            
            var strDescription : NSAttributedString!
            if let dataAttrubute = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                strDescription = dataAttrubute
            }
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 2
            strHeader.append(strSharedWith)
            strHeader.append(nextLine1)
            strHeader.append(strSharedInfo)
            strHeader.append(nextLine1)

            strHeader.append(strDescription)

            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            
        }
        return strHeader
    }
    func coachSideDescription() -> NSAttributedString{
        let strHeader = NSMutableAttributedString.init()
        if  let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE12), let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)
            
        {
            let strSharedWith = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Shared with : ", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:39),NSAttributedString.Key.font : fontMedium]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strSharedInfo = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: sharedWIthLogic(), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 23),NSAttributedString.Key.font : fontMedium]);
           
         
            
            let data = Data((self.noteResultModal?.data?.utf8)!)
            
            var strDescription : NSAttributedString!
            if let dataAttrubute = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                strDescription = dataAttrubute
            }
            
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 2
            strHeader.append(strSharedWith)
            strHeader.append(nextLine1)
            strHeader.append(strSharedInfo)
            strHeader.append(nextLine1)

            strHeader.append(strDescription)

            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            
        }
        return strHeader
    }
    
    
    
    
    
}
