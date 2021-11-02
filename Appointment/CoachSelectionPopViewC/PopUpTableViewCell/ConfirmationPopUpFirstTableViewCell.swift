//
//  ConfirmationPopUpFirstTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 08/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol changeModalConfirmationPopUpDelegate {
    
    func changeModal(searchItem : SearchTextFieldItem, indexPAth : IndexPath,isAdded: Bool)
       func sendApiResult(item: [SearchTextFieldItem],isApi: Bool)


}


class PaddedTextField: UITextField {
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: bounds.size.width-22, y: 6, width: 18, height: 18)
    }

}

class ConfirmationPopUpFirstTableViewCell: UITableViewCell {
    @IBOutlet weak var btnFirstIndex: UIButton!
    @IBOutlet weak var viewSelectedContainer: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewTextfield: UIView!
    @IBOutlet weak var txtField: PaddedTextField!
    @IBOutlet weak var lblNoResultFound: UILabel!
    var delegate: changeModalConfirmationPopUpDelegate!
//    var viewController : UIView!
    var viewControllerI : CoachConfirmationPopUpSecondViewC!
    var isAPiHIt : Bool!
    var tblview : UITableView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    var arrNameSurvey : [SearchTextFieldItem]!

    var indexPath : IndexPath!
     var arraYHeader = ["Purpose of the Meeting","Description","Target Functions (Max 3)","Target Industries (Max 3)","Target Companies (Max 3)"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func btnFirstIndexTapped(_ sender: UIButton) {
        
        var searchViewController = SearchViewController.init(nibName: "SearchViewController", bundle: nil)
        searchViewController.modalPresentationStyle = .overFullScreen
        searchViewController.maxHeight = 200;
        let frameI =
            sender.superview?.convert(sender.frame, to: nil)
            
        var placeholder = "Select"
        if indexPath.row == 5{
            placeholder = "Type minimum 2 characters to search"
        }
        else
        {
            placeholder = "Select"
        }
        
        searchViewController.placeholder = placeholder;
        var changedFrame = frameI

        var changeYaxis = 164 - (changedFrame?.origin.y)! ?? 0;
        
        if frameI!.origin.y > self.viewControllerI.view.frame.height/2{
            viewControllerI.viewOuter.frame = CGRect.init(x:  viewControllerI.viewOuter.frame.origin.x, y: changeYaxis, width: viewControllerI.viewOuter.frame.width, height: viewControllerI.viewOuter.frame.height)

            changedFrame = CGRect.init(x: (changedFrame?.origin.x)!, y: 100, width: (changedFrame?.size.width)!, height: (changedFrame?.size.height)!)
        }
        else if frameI!.origin.y > self.viewControllerI.view.frame.height/3{
            
            viewControllerI.viewOuter.frame = CGRect.init(x:  viewControllerI.viewOuter.frame.origin.x, y: changeYaxis, width: viewControllerI.viewOuter.frame.width, height: viewControllerI.viewOuter.frame.height)
            
            changedFrame = CGRect.init(x: (changedFrame?.origin.x)!, y: 100, width: (changedFrame?.size.width)!, height: (changedFrame?.size.height)!)
        }

        searchViewController.arrNameSurvey = self.arrNameSurvey.filter({$0.isSelected == false})
        searchViewController.txtfieldRect = changedFrame
        searchViewController.isAPiHIt = isAPiHIt
        if self.indexPath.row == 1{
            searchViewController.showWithoutText = true
        }
        else{
            searchViewController.showWithoutText = false
        }
        
        
        searchViewController.delegate = self
        
        viewControllerI.present(searchViewController, animated: false) {
        }
        
    }
    
    
    func customization()  {
        
        self.btnFirstIndex.isHidden = false
        setDynamicView()
        txtField.backgroundColor = ILColor.color(index: 22)
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        var placeholder = "Select"
        if indexPath.row == 5{
            placeholder = "Type minimum 2 characters to search"
        }
        else
        {
            placeholder = "Select"
        }
        
        txtField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: ILColor.color(index: 32),
            .font: fontMedium
        ])
        
        let imageView = UIImageView.init(image: UIImage.init(named: "dropdown"))
            imageView.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        imageView.contentMode = .center
        txtField.rightView = imageView
        txtField.rightViewMode = .always

        
        let strHeader = NSMutableAttributedString.init()

        
        if let fontNextMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
               {
                   let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: arraYHeader[indexPath.row - 1], _returnType: String.self)
                       , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontNextMedium]);
                   let strType = NSAttributedString.init(string: " ⃰"
                    , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontNextMedium]);
                   let para = NSMutableParagraphStyle.init()
                   //            para.alignment = .center
                   strHeader.append(strTiTle)
                if indexPath.row == 1{
                     strHeader.append(strType)
                }
                  
                   strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
                   lblHeader.attributedText = strHeader
               }
         
        
       var alreadyAdded = self.arrNameSurvey.filter({$0.isSelected == true})
        
        if alreadyAdded.count > 0{
            if alreadyAdded.count == self.arrNameSurvey[0].maxValue{
                self.btnFirstIndex.isHidden = true
                self.txtField.isUserInteractionEnabled = false
                txtField.backgroundColor = ILColor.color(index: 20)
            }
            else{
                self.btnFirstIndex.isHidden = false
                self.txtField.isUserInteractionEnabled = true
                txtField.backgroundColor = ILColor.color(index: 22)
            }

        }
        
        
        
        
        
    }
    
    
        
    
    func setDynamicView()
    {
        for view in   self.viewSelectedContainer.subviews
        {
            view.removeFromSuperview()
        }
        var viewPrevius : UIView?;
        var viewPreviusC : UIView?;
        self.viewHeightConstraint.constant = 0
        var sumWidth : CGFloat = 0.0
        let arrView = self.arrNameSurvey.filter({$0.isSelected == true})
        var index = 0
        for searchItem in arrView{
            let view = UIView();
            view.backgroundColor =  ColorCode.applicationBlue
            viewSelectedContainer.addSubview(view);
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = searchItem.id!;
            self.innverView(viewC: view, str: arrView[index].title);
            if (viewPrevius != nil)
            {
                view.layoutIfNeeded();
                viewPrevius!.layoutIfNeeded();
                sumWidth = sumWidth + (viewPrevius?.frame.width)! + 8
                view.cornerRadius = 5;
                
                if (sumWidth + view.frame.width + 8 < self.frame.width)
                {
                    viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewPrevius]-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevius":viewPrevius!,"view" :view ]))
                    if (viewPreviusC != nil)
                    {
                        viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPreviusC]-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPreviusC":viewPreviusC!,"view" :view ]))
                    }
                    else
                    {
                        viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                    }
                }
                else
                {
                    viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevius":viewPrevius!,"view" :view ]))
                    viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevius]-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevius":viewPrevius!,"view" :view ]))
                    view.layoutIfNeeded();
                                       if (view.frame.width  >= self.frame.width){
                                           viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-8-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                                       }
                                       
                    self.viewHeightConstraint.constant = self.viewHeightConstraint.constant + 35;
                    viewPreviusC = viewPrevius
                    sumWidth = 0;
                }
                viewPrevius = view;
            }
            else
            {
                view.layoutIfNeeded();
                view.cornerRadius = 5;
                viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                viewPrevius = view;
                self.viewHeightConstraint.constant = self.viewHeightConstraint.constant + 35;
                view.layoutIfNeeded();
                if (view.frame.width  >= self.frame.width){
                     viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-8-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                }
            }
            index = index + 1
        }
    }
    
    func  innverView(viewC : UIView,str: String)  {
        let fontNextMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)

        let viewLbl = UILabel();
        viewC.addSubview(viewLbl);
        viewLbl.text = str;
        viewLbl.font = fontNextMedium!
        viewLbl.textColor = UIColor.white
        viewLbl.translatesAutoresizingMaskIntoConstraints = false
        
        
        viewC.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(6)-[viewLbl]-(6)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewLbl" :viewLbl ]))
        
        
        let viewBtn = UIButton();
        viewC.addSubview(viewBtn);
        viewBtn.tag = viewC.tag
        viewBtn.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "noun_Cross")
        viewBtn.setImage(image, for: .normal)
        viewBtn.imageEdgeInsets = UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 3)
        viewBtn.imageView?.tintColor = UIColor.white
        
        viewBtn.imageView?.contentMode = .center
        
        viewC.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[viewLbl]-(4)-[viewBtn(==18)]-(8)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewLbl" :viewLbl,"viewBtn" :viewBtn ]))
        
        let verticalCentre = NSLayoutConstraint.init(item: viewBtn, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewC, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        
        viewC.addConstraints([verticalCentre]);
        
        viewC.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewBtn(==18)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewBtn" :viewBtn ]))
        viewBtn.tag = viewC.tag
        viewBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton){
        var selecetedItem = arrNameSurvey.filter({$0.id == sender.tag})[0]
        self.delegate.changeModal(searchItem: selecetedItem, indexPAth: self.indexPath, isAdded: false)
//        self.txtField.hideResultsList()
        self.txtField.text = ""
        self.txtField.endEditing(true)
    }
    
}

extension ConfirmationPopUpFirstTableViewCell: SearchViewControllerDelegate{
    func sendApiResult(item: [SearchTextFieldItem],isApi: Bool) {
        self.delegate.sendApiResult(item: item, isApi: isApi)
    }
    
    
    func sendSelectedItem(item: SearchTextFieldItem) {
        self.delegate.changeModal(searchItem: item, indexPAth: self.indexPath, isAdded: true)
        
    }
    
    
}
