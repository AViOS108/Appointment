//
//  AppointmentCancelViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 02/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class AppointmentCancelViewController: UIViewController,UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblCancel: UILabel!
    
    @IBOutlet weak var lblDesce: UILabel!
    
    @IBAction func denyCancelTapped(_ sender: Any) {
    }
    
    @IBOutlet var viewSeprators: [UIView]!
    @IBOutlet weak var denyCancel: UIButton!
    
    @IBOutlet weak var confirmationCancel: UIButton!
    
    @IBOutlet weak var viewInner: UIView!
    
    @IBAction func confirmationCancelTapped(_ sender: Any) {
    }
    
    var selectedAppointmentModal : OpenHourCoachModalResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func customization()  {
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE16)
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        UILabel.labelUIHandling(label: lblCancel, text: "Cancel Schedule", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
        
        UILabel.labelUIHandling(label: lblDesce, text: "Are you sure, you want to cancel this schedule with Alima Amos?", textColor: ILColor.color(index: 42), isBold: false, fontType: fontHeavy1)
        
        
        self.viewSeprators.forEach { (viewSeperator) in
            viewSeperator.backgroundColor = ILColor.color(index: 22)
        }
        
        UIButton.buttonUIHandling(button: denyCancel, text: "No", backgroundColor: .white, textColor: ILColor.color(index: 23), cornerRadius: 3,  borderColor: ILColor.color(index: 23), borderWidth: 1, fontType: fontMedium)
        
        UIButton.buttonUIHandling(button: denyCancel, text: "Yes", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3,   fontType: fontMedium)
        
        // corner radius
        viewContainer.layer.cornerRadius = 10
        
        // border
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.borderColor = ILColor.color(index: 27).cgColor
        
        // shadow
        viewContainer.layer.shadowColor = ILColor.color(index: 27).cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewContainer.layer.shadowOpacity = 0.7
        viewContainer.layer.shadowRadius = 4.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
          self.view.tag = 19682
          self.viewInner.tag = 19683
          tapGesture()
          view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
          viewInner.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
          viewContainer.backgroundColor = .white
          viewContainer.cornerRadius = 3;
          
          self.customization()
          
      }
      
      func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
          if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682  {
              self.view.resignFirstResponder()
              
              return false
          }
          return true
      }
      
      func tapGesture()  {
          let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
          tap.delegate = self
          self.viewInner.isUserInteractionEnabled = true
          self.viewInner.addGestureRecognizer(tap)
      }
      
      @objc func handleTap(_ sender: UITapGestureRecognizer) {
          self.dismiss(animated: false) {
          }
      }
     
}
