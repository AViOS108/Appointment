//
//  SearchViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
import SwiftyJSON



protocol SearchViewControllerDelegate {
    func sendSelectedItem(item: SearchTextFieldItem)
    func sendApiResult(item: [SearchTextFieldItem],isApi: Bool)
    
}


extension SearchViewControllerDelegate{
    func sendApiResult(item: [SearchTextFieldItem],isApi: Bool)
    {
        
    }
    
}




class SearchViewController: SuperViewController {
    var activityIndicator: ActivityIndicatorView?
    var viewControllerI : UIViewController!
    var txtfieldRect: CGRect!
    var maxHeight = 0;
    var isAPiHIt : Bool!
    
    var isCreateNew : Bool = false

    var delegate : SearchViewControllerDelegate!
    var textField : UITextField!
    var selectedTextZone : String!
    var tblView: UITableView!
    var arrNameSurvey = [SearchTextFieldItem]()
    var arrNameSurveyConst : [SearchTextFieldItem]!
    let indicator = UIActivityIndicatorView(style: .gray)
    var placeholder : String!
var showWithoutText = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        arrNameSurveyConst = arrNameSurvey
                view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
//        view.backgroundColor = .clear
        
        self.view.tag = 19682
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
        
        textField = UITextField.init(frame: txtfieldRect)
        self.view.addSubview(textField)
        tblView = UITableView.init(frame: CGRect.init(x: txtfieldRect.origin.x, y: txtfieldRect.origin.y + txtfieldRect.size.height, width: txtfieldRect.size.width, height: 200))
        textField.backgroundColor = .white
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        self.textField.text = selectedTextZone
        self.textField.font = fontHeavy
        self.textField.layer.borderColor = ILColor.color(index: 22).cgColor
        self.textField.layer.borderWidth = 1;
        self.textField.becomeFirstResponder()
        
        textField.backgroundColor = ILColor.color(index: 22)
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: ILColor.color(index: 32),
            .font: fontMedium
        ])
        
        
       let imageView = UIImageView.init(image: UIImage.init(named: "dropdown"))
        imageView.contentMode = .center
        imageView.frame.size = CGSize.init(width: 20, height: 20)
        textField.rightView = imageView
        textField.rightViewMode = .always

        
        tblView.register(UINib.init(nibName: "TimeZoneTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeZoneTableViewCell")
        tblView.dataSource = self
        tblView.delegate = self
        tblView.separatorStyle = .none
        self.view.addSubview(tblView)
        
        tblView.reloadData()
        
        let height = min(tblView.contentSize.height, CGFloat(maxHeight))
        
        
        if    self.view.frame.size.height  < tblView.frame.origin.y + height{
         
            tblView.frame =  CGRect.init(x: tblView.frame.origin.x, y: tblView.frame.origin.y, width:  tblView.contentSize.width, height:   self.view.frame.size.height - tblView.frame.origin.y - 30)
            
        }
        else{
          tblView.frame =  CGRect.init(x: tblView.frame.origin.x, y: tblView.frame.origin.y, width:  tblView.contentSize.width, height:  height)
        }
        
        self.addInputAccessoryForTextFields(textFields: [textField], dismissable: true, previousNextable: false)
        
         
        self.tapGesture()
        // Do any additional setup after loading the view.
    }
    
    override  func actnResignKeyboard() {
        self.delegate.sendApiResult(item: arrNameSurvey, isApi: isAPiHIt);
        textField.resignFirstResponder()
        self.dismiss(animated: false) {
            
        }
        
      }
    
    
     func tapGesture()  {
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
           tap.delegate = self
           self.view.isUserInteractionEnabled = true
           self.view.addGestureRecognizer(tap)
       }
           
       @objc func handleTap(_ sender: UITapGestureRecognizer) {
           
        self.delegate.sendApiResult(item: arrNameSurvey, isApi: isAPiHIt);
        
           self.dismiss(animated: false) {
               
           }
           
       }
    
}
extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZoneTableViewCell", for: indexPath) as! TimeZoneTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.customize(timeZonetitle: arrNameSurvey[indexPath.row].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if showWithoutText {
//            return arrNameSurvey.count
//        }
//        else if self.textField.text!.isEmpty{
//            return 0
//
//        }
//
        return arrNameSurvey.count
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        self.textField.text = self.timeZoneArrI[indexPath.row].displayName;
        
        if isAPiHIt{
            self.delegate.sendApiResult(item: arrNameSurvey, isApi: isAPiHIt);
        }
        self.delegate.sendSelectedItem(item: self.arrNameSurvey[indexPath.row])
        self.dismiss(animated: false) {
            
        }
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
}
extension SearchViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
     if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682  {
               return false
            }
            return true
       }
    
}


extension SearchViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        self.textField.text = currentText

        
        if arrNameSurvey.count > 0{
            
            if currentText.isEmpty{
                arrNameSurvey = arrNameSurveyConst
            }
            else{
                arrNameSurvey = arrNameSurveyConst.filter({$0.title.lowercased().contains(currentText.lowercased())})
                if isCreateNew {
                    
                    let searchItem = SearchTextFieldItem()
                    searchItem.title = "Create New " + "'\(textField.text ?? "")'"
                    searchItem.isSelected = true;
                    searchItem.id  = -1000
                    arrNameSurvey.insert(searchItem, at: 0)
                }
                
            }
            reloadAndSizeTableView()
            
        }
        else{
             arrNameSurvey = arrNameSurveyConst
             reloadAndSizeTableView()
        }
        
        if isAPiHIt{
            
            if currentText.count >= 2{
                self.textField.rightView  = indicator
                self.textField.rightViewMode = .always
                indicator.startAnimating()
                self.globalCompanies(strText: currentText);
                
            }
            
        }
        
        
        return false
    }
}






extension SearchViewController{
    
    func reloadAndSizeTableView(){
        self.tblView.reloadData()
        
        let height = min(tblView.contentSize.height, CGFloat(maxHeight))
        
        if    self.view.frame.size.height  < tblView.frame.origin.y + height{
            
            tblView.frame =  CGRect.init(x: tblView.frame.origin.x, y: tblView.frame.origin.y, width:  tblView.contentSize.width, height:   self.view.frame.size.height - tblView.frame.origin.y - 30)
            
        }
        else{
            tblView.frame =  CGRect.init(x: tblView.frame.origin.x, y: tblView.frame.origin.y, width:  tblView.contentSize.width, height:  height)
        }
    }
    
    
    
    func globalCompanies(strText:String)
       {
       
        
        IndustriesFunctionViewModal().globalCompnies(strText, { (response) in
             do {
                          try self.setupglobalCompanies(response: response);
                   } catch {

            }
        }) { (error, errorCode) in
            
        }
       }
    
    
    func setupglobalCompanies(response : JSON)  throws{
        var resueGlobalCompaies : [GlobalCompaies] = [GlobalCompaies]()
        for (_,companies) in response{
            var globalCompanies = GlobalCompaies();
            globalCompanies.id = companies["id"].int ?? 0
            globalCompanies.name = companies["name"].string ?? ""
            globalCompanies.domainName = companies["domain_name"].string ?? ""
                
            globalCompanies.scoreName = companies["score_name"].int ?? 0
            globalCompanies.scoreDomainName = companies["score_domain_name"].int ?? 0
            resueGlobalCompaies.append(globalCompanies);
        }
//        self.resueStudentIndustryI = resueStudentIndustry;
        
      
        
        for result in resueGlobalCompaies{
            let searchItem = SearchTextFieldItem()
            searchItem.title = result.name!;
            searchItem.id = result.id;
            searchItem.isSelected = false
            searchItem.maxValue = 3;
            arrNameSurvey.append(searchItem)
        }
        
        indicator.stopAnimating()
        let imageView = UIImageView.init(image: UIImage.init(named: "dropdown"))
        imageView.contentMode = .center
        imageView.frame.size = CGSize.init(width: 20, height: 20)
        textField.rightView = imageView
        textField.rightViewMode = .always
        reloadAndSizeTableView()
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           
           super.viewWillTransition(to: size, with: coordinator)
          self.dismiss(animated: false) {
                    
                }
        
        coordinator.animate(alongsideTransition: nil, completion: { (_) in
            self.reloadAndSizeTableView()
              
           })
           
       }
    
    

}



