//
//  ConfirmationPopupFileShareTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
import MobileCoreServices


protocol ConfirmationPopupFileShareTableViewCellDelegate {
    func sendDocument(data: DocUploadedModal)
}



class ConfirmationPopupFileShareTableViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var viewDocumentSelected: UIView!
    @IBOutlet weak var btnDocSelected: UIButton!
    
    var docUploaded : DocUploadedModal!
    @IBAction func btnDocSelectedTapped(_ sender: Any) {
        self.docUploaded.docName =  ""
        self.docUploaded.isDocUploaded = false
        self.docUploaded.docData = nil
        self.delegate.sendDocument(data: self.docUploaded)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var documentPicker: UIDocumentPickerViewController!
    var viewControllerI : UIViewController!
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var imageAttached: UIImageView!
    @IBOutlet weak var btnFileAttached: UIButton!
    var delegate : ConfirmationPopupFileShareTableViewCellDelegate!
    @IBAction func btnFileAttachedTapped(_ sender: Any) {
        OpenFileManager()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
    func customization() {
        if docUploaded.isDocUploaded!{
            self.viewDocumentSelected.isHidden = false
            self.btnDocSelected.setTitle(docUploaded.docName, for: .normal)
            self.btnDocSelected.setImage(UIImage.init(named: "Cross"), for: .normal)
            btnDocSelected.setTitleColor(.black, for: .normal)
            self.imageAttached.isHidden = true
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            btnDocSelected.titleLabel?.font = fontMedium
            
            self.lblBottom.isHidden = true
            self.btnFileAttached.isHidden = true
            btnDocSelected.backgroundColor = ILColor.color(index: 22)
            
        }
        else{
            
            self.imageAttached.isHidden = false
            self.lblBottom.isHidden = false
            self.btnFileAttached.isHidden = false
            self.viewDocumentSelected.isHidden = true
            btnFileAttached.setTitle("Attach File", for: .normal)
            btnFileAttached.titleLabel?.textAlignment = .left
            btnFileAttached.setTitleColor(ILColor.color(index: 23), for: .normal)
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            
            btnFileAttached.titleLabel?.font = fontMedium
            
            let fontNextMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
            UILabel.labelUIHandling(label: lblBottom, text: "If you want to share with the coach", textColor:ILColor.color(index: 31) , isBold: false , fontType: fontNextMedium,   backgroundColor:.white )
            imageAttached.image = UIImage.init(named: "noun_Attachment")
            
            documetPicker()
        }
    }
    
}

extension ConfirmationPopupFileShareTableViewCell: UIDocumentPickerDelegate
{
    func OpenFileManager()  {
        if #available(iOS 11.0, *) {
            viewControllerI.present(documentPicker, animated: true, completion: {
                self.documentPicker.allowsMultipleSelection = false
            })
        } else {
            CommonFunctions().showError(title: "Error", message: StringConstants.KUPGRADETOLATESTOS)
        }
    }
    func documetPicker(){
        documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
    }
    
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
        if urls.count > 0{
            
             let docURL = urls[0]
            
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let imageData: Data = try Data(contentsOf: docURL)
                    
                    self.docUploaded.docName =  docURL.lastPathComponent
                    self.docUploaded.isDocUploaded = true
                    self.docUploaded.docData = imageData
                    
                    DispatchQueue.main.async {
                        self.delegate.sendDocument(data: self.docUploaded)
                    }
                   
                   
                    
                }catch{
                    print("Unable to load data: \(error)")
                }
            }
        }
        
        
        
    }
    
    // called if the user dismisses the document picker without selecting a document (using the Cancel button)
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    {
        
    }
    
}
