//
//  TimeZoneViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 01/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit







protocol TimeZoneViewControllerDelegate {
    
    func sendTimeZoneSelected(timeZone: TimeZoneSel)
    
}


class TimeZoneViewController: UIViewController {
    var activityIndicator: ActivityIndicatorView?
    var viewControllerI : UIViewController!
    var txtfieldRect: CGRect!
    
    var delegate : TimeZoneViewControllerDelegate!
    
    var timeZoneArrI = [TimeZoneSel]()
    var textField : LeftPaddedTextField!
    var selectedTextZone : String!

    
     var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        self.view.tag = 19682
        timeZoneArrI = DashBoardViewModel().filterTimeZone(text: "")
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)

        textField = LeftPaddedTextField.init(frame: txtfieldRect)
        
        textField.becomeFirstResponder()
        
        self.view.addSubview(textField)
        tblView = UITableView.init(frame: CGRect.init(x: txtfieldRect.origin.x, y: txtfieldRect.origin.y + txtfieldRect.size.height, width: txtfieldRect.size.width, height: 200))
        textField.backgroundColor = .white
        textField.delegate = self
        self.textField.text = selectedTextZone
        self.textField.font = fontHeavy
        self.textField.layer.borderColor = ILColor.color(index: 27).cgColor
        self.textField.layer.borderWidth = 1;
        self.textField.becomeFirstResponder()
        
        tblView.register(UINib.init(nibName: "TimeZoneTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeZoneTableViewCell")
        tblView.dataSource = self
        tblView.delegate = self
        tblView.separatorStyle = .none
        self.view.addSubview(tblView)
        
        
        self.tapGesture()
        // Do any additional setup after loading the view.
    }
    
    func reloadTableview()  {
        textField.becomeFirstResponder()

        tblView.reloadData()
    }
    
    func tapGesture()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
    }
        
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        viewControllerI!.dismiss(animated: false) {
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    

}


extension TimeZoneViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZoneTableViewCell", for: indexPath) as! TimeZoneTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.customize(timeZonetitle: self.timeZoneArrI[indexPath.row].displayName ?? "")
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeZoneArrI.count
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.textField.text = self.timeZoneArrI[indexPath.row].displayName;
        UserDefaultsDataSource(key: "timeZoneOffset").writeData(self.timeZoneArrI[indexPath.row].identifier)
        delegate.sendTimeZoneSelected(timeZone: self.timeZoneArrI[indexPath.row]);
        viewControllerI!.dismiss(animated: false) {
             
         }
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
}
extension TimeZoneViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
     if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682  {
               return false
            }
            return true
       }
    
}


extension TimeZoneViewController: UITextFieldDelegate{

      func textFieldDidBeginEditing(_ textField: UITextField)
     {
       if  self.timeZoneArrI.contains(where: {$0.displayName == textField.text}){
                  self.textField.text = ""
              }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
                guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        timeZoneArrI = DashBoardViewModel().filterTimeZone(text: currentText)
        self.tblView.reloadData()
        return true
    }
}
