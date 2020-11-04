//
//  EditNotesViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 06/10/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol EditNotesViewControllerDelegate {
    func refreshApi()

}



class EditNotesViewController: SuperViewController,UIGestureRecognizerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblEditNote: UILabel!
    
    var identifier : String!
    
    var delegate : EditNotesViewControllerDelegate!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
    
    var objNoteModal :   NotesResult?
    
    
    @IBOutlet weak var viewSeperator: UIView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var activityIndicator: ActivityIndicatorView?

    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        if txtView.text.isEmpty || (txtView.text == "Your notes here" && txtView.textColor == .lightGray ){
            CommonFunctions().showError(title: "", message: "Note can't be blank")
        }
        else{
            objNoteModal?.data = txtView.text
            let objAppointment = AppoinmentdetailViewModal()
            activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.SavingNotes)
            objAppointment.callbackVC = {
                (success:Bool) in
                self.activityIndicator?.hide()
                if success{
                    self.dismiss(animated: false) {
                        self.delegate?.refreshApi()
                    }
                }
            }
            objAppointment.saveNotes(objnoteModal: objNoteModal,text : txtView.text, identifier: identifier ?? "")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customization()
        
       
        
        
    }
    
    func customization()  {
        self.viewOuter.tag = 19682
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
        let fontBold = UIFont(name: "FontBold".localized(), size: Device.FONTSIZETYPE15)
        viewSeperator.backgroundColor = ILColor.color(index: 22)
        
        viewContainer.backgroundColor = .white
        
        
        txtView.backgroundColor = ILColor.color(index: 22)
        txtView.autocorrectionType = .no
        txtView.spellCheckingType = .no
        txtView.font = fontMedium
        txtView.delegate = self
        txtView.layer.borderWidth = 1;
        txtView.layer.borderColor = ILColor.color(index: 22).cgColor
        txtView.text = "Your notes here"
        txtView.textColor = .lightGray
        self.addInputAccessoryForTextView(textVIew: txtView )
        btnCancel.setImage(UIImage.init(named: "Cross"), for: .normal)
        
        self.viewOuter.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        UILabel.labelUIHandling(label: lblEditNote, text: "Edit Note", textColor: ILColor.color(index: 39), isBold: false, fontType: fontBold)
        let weekDay = ["Sun","Mon","Tues","Wed","Thu","Fri","Sat"]
        let componentDay = GeneralUtility.dateComponent(date: self.objNoteModal?.createdAt ?? "", component: .weekday)
        let date = GeneralUtility.currentDateDetailType4(emiDate: self.objNoteModal?.createdAt ?? "");
        let timeText = "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " + date;
        UILabel.labelUIHandling(label: lblDate, text: timeText, textColor: ILColor.color(index: 39), isBold: false, fontType: fontMedium)
        UIButton.buttonUIHandling(button: btnSave, text: "Save", backgroundColor:   ILColor.color(index: 8), textColor: .white, cornerRadius: 2,  fontType: fontMedium)
        tapGesture()
        
        if !(objNoteModal?.data?.isEmpty ?? true){
            txtView.text = objNoteModal?.data
            txtView.textColor = .black
        }
        else
        {
           
            
        }
        
       
        
    }
    
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.view) == true && touch.view?.tag != 19682  {
            return false
        }
        return true
    }
    
    func tapGesture()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.viewOuter.isUserInteractionEnabled = true
        self.viewOuter.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false) {
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Your notes here" && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Your notes here"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
    override func actnResignKeyboard() {
        txtView.resignFirstResponder()
    }
    
}
