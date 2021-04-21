//
//  NotesAppointmentTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 23/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol NotesAppointmentTableViewCellDelegate {
    
    func addNotes()
}

enum noteViewType {
    case studentType
    case erType
}


class NotesAppointmentTableViewCell: TableviewCellSuperClass,UITextViewDelegate {
    
    var activityIndicator: ActivityIndicatorView?
    var objNoteViewType : noteViewType!
    @IBOutlet weak var viewMyNotes: UIView!
    var viewController : UIViewController!
    @IBOutlet weak var lblMyNotes: UILabel!
    
    var delegate : NotesAppointmentTableViewCellDelegate?
    var appoinmentDetailAllModalObj: ApooinmentDetailAllNewModal?
    
    
    @IBOutlet weak var btnMyNotes: UIButton!
    
    @IBAction func btnMyNotesTapped(_ sender: Any) {
        delegate?.addNotes()
    }
    
    @IBOutlet weak var viewCollectionMyNotes: NoteCollectionView!
    
    //    @IBOutlet weak var nslayoutConstraintMyNoteCollection: NSLayoutConstraint!
    //    @IBOutlet weak var nslayoutConstraintMyNoteCollectionWidth: NSLayoutConstraint!
    
    @IBOutlet weak var viewContainer: UIView!
    
   
    
    
    
    func customization()  {
        self.backgroundColor = .clear
        self.layoutIfNeeded()
        let fontNextMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)

        myNotesCustomization()
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        
    }
    
    
    
    func myNotesCustomization()  {
        viewCollectionMyNotes.register(UINib.init(nibName: "NoteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NoteCollectionViewCell")
        viewCollectionMyNotes.noteModalObj = appoinmentDetailAllModalObj?.noteModalObj;
        viewCollectionMyNotes.viewController = viewController
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        
        UIButton.buttonUIHandling(button: btnMyNotes, text: "Add Notes", backgroundColor: .clear, textColor: ILColor.color(index: 23))
        viewMyNotes.backgroundColor = .clear
        UILabel.labelUIHandling(label: lblMyNotes, text: "Notes", textColor: ILColor.color(index: 34), isBold: false,fontType: fontHeavy)
        viewCollectionMyNotes.objNoteViewType = self.objNoteViewType
        viewCollectionMyNotes.customize()
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
