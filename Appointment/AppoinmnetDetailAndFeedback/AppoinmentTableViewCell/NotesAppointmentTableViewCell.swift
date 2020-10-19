//
//  NotesAppointmentTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 23/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol NotesAppointmentTableViewCellDelegate {
    
    func changeNumberOfNotes(isMyCoach : Bool)
    func refreshApi()
}


class NotesAppointmentTableViewCell: TableviewCellSuperClass,UITextViewDelegate {
    
    var activityIndicator: ActivityIndicatorView?

    
    @IBOutlet weak var BtnSaveNotes: UIButton!
    
    @IBAction func BtnSavesTapped(_ sender: Any) {
        if txtView.text.isEmpty || (txtView.text == "Your notes here" && txtView.textColor == .lightGray ){
            CommonFunctions().showError(title: "", message: "Note can't be blank")
        }
        else{
            let objAppointment = AppoinmentdetailViewModal()
            activityIndicator = ActivityIndicatorView.showActivity(view: viewController.view, message: StringConstants.SavingNotes)
            objAppointment.callbackVC = { (success:Bool) in
                 self.activityIndicator?.hide()
                if success{
                    self.delegate?.refreshApi()
                }
                
            }
            objAppointment.saveNotes(objnoteModal: nil,text : txtView.text, identifier: appoinmentDetailAllModalObj?.appoinmentDetailModalObj?.identifier ?? "")
        }
    }
    
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var viewMyNotes: UIView!
    var viewController : UIViewController!
    @IBOutlet weak var lblMyNotes: UILabel!
    
    var delegate : NotesAppointmentTableViewCellDelegate?
    var appoinmentDetailAllModalObj: ApooinmentDetailAllModal?

    
    @IBOutlet weak var btnMyNotes: UIButton!
    
    @IBAction func btnMyNotesTapped(_ sender: Any) {
        delegate?.changeNumberOfNotes(isMyCoach: true)
    }
    
    @IBOutlet weak var viewCollectionMyNotes: NoteCollectionView!
    
    //    @IBOutlet weak var nslayoutConstraintMyNoteCollection: NSLayoutConstraint!
    //    @IBOutlet weak var nslayoutConstraintMyNoteCollectionWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewCoachNotes: UIView!
    
    @IBOutlet weak var lblCoachNotes: UILabel!
    
    @IBOutlet weak var btnCoachNotes: UIButton!
    
    @IBAction func btnCoachNotesTapped(_ sender: Any) {
        delegate?.changeNumberOfNotes(isMyCoach: false)

    }
    @IBOutlet weak var viewCollectionCoachNotes: NoteCollectionView!
    @IBOutlet weak var viewContainer: UIView!

    
    
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
       }
    
    
    
    func customization()  {
        
        self.layoutIfNeeded()
        let fontNextMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        self.viewContainer.backgroundColor = .white
        self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 3)

        UIButton.buttonUIHandling(button: BtnSaveNotes, text: "Save", backgroundColor: .clear, textColor: ILColor.color(index: 31), cornerRadius: 2, borderColor: ILColor.color(index: 31), borderWidth:1,  fontType: fontNextMedium)
        myNotesCustomization()
        coachNotesCustomization()
        self.addInputAccessoryForTextView(textVIew: txtView )
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        UILabel.labelUIHandling(label: lblHeader, text: "Notes", textColor:ILColor.color(index: 31) , isBold: false , fontType: fontHeavy,   backgroundColor:.white )
        txtView.backgroundColor = ILColor.color(index: 22)
        txtView.autocorrectionType = .no
        txtView.spellCheckingType = .no
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtView.font = fontMedium
        txtView.delegate = self
        txtView.layer.borderWidth = 1;
        txtView.layer.borderColor = ILColor.color(index: 22).cgColor
        txtView.text = "Your notes here"
        txtView.textColor = .lightGray
    }
    
    
    
    func myNotesCustomization()  {
        viewCollectionMyNotes.register(UINib.init(nibName: "NoteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NoteCollectionViewCell")
        viewCollectionCoachNotes.mynotes = true

        viewCollectionMyNotes.noteModalObj = appoinmentDetailAllModalObj?.noteModalObj;        viewCollectionMyNotes.viewController = viewController
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)

        if appoinmentDetailAllModalObj?.noteModalObj?.isExpandableNotes ?? true{
            btnMyNotes.setImage(UIImage.init(named: "drop_down"), for: .normal)

        }
        else{
              btnMyNotes.setImage(UIImage.init(named: "drop_down1"), for: .normal)
            
        }
        
        viewMyNotes.backgroundColor = ILColor.color(index: 25)
        UILabel.labelUIHandling(label: lblMyNotes, text: "My Notes", textColor: .white, isBold: false,fontType: fontHeavy)
        viewCollectionMyNotes.customize()
    }
    
    func coachNotesCustomization()  {
        viewCollectionCoachNotes.register(UINib.init(nibName: "NoteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NoteCollectionViewCell")
        viewCollectionCoachNotes.mynotes = false
        viewCollectionCoachNotes.noteModalObj = appoinmentDetailAllModalObj?.coachNoteModalObj;
        viewCollectionCoachNotes.viewController = viewController
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        
        if appoinmentDetailAllModalObj?.coachNoteModalObj?.isExpandableNotes ?? true{
            btnCoachNotes.setImage(UIImage.init(named: "drop_down"), for: .normal)

        }
        else{
              btnCoachNotes.setImage(UIImage.init(named: "drop_down1"), for: .normal)
            
        }
        
        
        viewCoachNotes.backgroundColor = ILColor.color(index: 25)
        UILabel.labelUIHandling(label: lblCoachNotes, text: "Notes by Coach", textColor: .white, isBold: false,fontType: fontHeavy)
        
        viewCollectionCoachNotes.customize()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Your notes here" && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
            BtnSaveNotes.isHidden = false
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Your notes here"
            textView.textColor = .lightGray
            BtnSaveNotes.isHidden = true
        }
        textView.resignFirstResponder()
    }
    
    override func actnResignKeyboard() {
        txtView.resignFirstResponder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
