//
//  ERNotesStudentSelectTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 22/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERNotesStudentSelectTableViewCellDelegate {
    func changeModal(searchItem : SearchTextFieldItem, isAdded: Bool)
}


class ERNotesStudentSelectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnFirstIndex: UIButton!
    @IBOutlet weak var btnSelected: UIButton!
    @IBOutlet weak var vieContainner: UIView!
    
    @IBAction func btnSelectedTapped(_ sender: Any) {
        
        if !isSelectedT {
            btnSelected.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
            viewSelectedContainer.isHidden = false
                      viewTextfield.isHidden = false
            isSelectedT = true

        }
        else {
            isSelectedT = false
            btnSelected.setImage(UIImage.init(named: "check_box"), for: .normal)
                 self.viewHeightConstraint.constant = 0
            viewSelectedContainer.isHidden = true
            viewTextfield.isHidden = true
        }
        
    }
    @IBOutlet weak var viewSelectedContainer: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewTextfield: UIView!
    @IBOutlet weak var txtField: PaddedTextField!

    var isSelectedT = true
    
    var delegate: ERNotesStudentSelectTableViewCellDelegate!
    var viewController : UIView!
    var viewControllerI : UIViewController!
    var isAPiHIt = false
    var tblview : UITableView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    var arrNameSurvey : [SearchTextFieldItem]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func btnFirstIndexTapped(_ sender: UIButton) {
        
        let searchViewController = SearchViewController.init(nibName: "SearchViewController", bundle: nil)
        searchViewController.modalPresentationStyle = .overFullScreen
        searchViewController.maxHeight = 200;
        let frameI =
            sender.superview?.convert(sender.frame, to: nil)
        
        let placeholder = "Select Student"
        
        searchViewController.placeholder = placeholder;
        
        var changedFrame = frameI
        
        if frameI!.origin.y > self.viewControllerI.view.frame.height/2{

            tblview.contentOffset = CGPoint.init(x: tblview.contentOffset.x, y: tblview.contentOffset.y + 300)
            changedFrame = CGRect.init(x: (changedFrame?.origin.x)!, y: ((changedFrame?.origin.y)! - 300), width: (changedFrame?.size.width)!, height: (changedFrame?.size.height)!)
        }
        else if frameI!.origin.y > self.viewControllerI.view.frame.height/3{
            tblview.contentOffset = CGPoint.init(x: tblview.contentOffset.x, y: tblview.contentOffset.y + 200)
            changedFrame = CGRect.init(x: (changedFrame?.origin.x)!, y: ((changedFrame?.origin.y)! - 200), width: (changedFrame?.size.width)!, height: (changedFrame?.size.height)!)
        }
        
        searchViewController.arrNameSurvey = self.arrNameSurvey.filter({$0.isSelected == false})
        searchViewController.txtfieldRect = changedFrame
        searchViewController.isAPiHIt = isAPiHIt
//        if self.indexPath.row == 0{
//            searchViewController.showWithoutText = true
//        }
//        else{
//            searchViewController.showWithoutText = false
//        }
        
        
        searchViewController.delegate = self
        
        viewControllerI.present(searchViewController, animated: false) {
        }
        
    }
    
    
    func customization()  {
        
        self.btnFirstIndex.isHidden = false
        btnSelected.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
        setDynamicView()
        txtField.backgroundColor = ILColor.color(index: 22)
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        let placeholder = "Select Student"
        txtField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: ILColor.color(index: 32),
            .font: fontMedium!
        ])
        
        let imageView = UIImageView.init(image: UIImage.init(named: "dropdown"))
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        imageView.contentMode = .center
        txtField.rightView = imageView
        txtField.rightViewMode = .always
        
        UILabel.labelUIHandling(label: lblHeader, text: "Students", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium)
        
        var alreadyAdded = self.arrNameSurvey.filter({$0.isSelected == true})

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
        self.delegate.changeModal(searchItem: selecetedItem, isAdded: false)
//        self.txtField.hideResultsList()
        self.txtField.text = ""
        self.txtField.endEditing(true)
    }
    
}
extension ERNotesStudentSelectTableViewCell: SearchViewControllerDelegate{
    
    func sendSelectedItem(item: SearchTextFieldItem) {
        self.delegate.changeModal(searchItem: item,  isAdded: true)
        
    }
    func sendApiResult(item: [SearchTextFieldItem],isApi: Bool)
    {
        tblview.reloadData()
    }
    
}
