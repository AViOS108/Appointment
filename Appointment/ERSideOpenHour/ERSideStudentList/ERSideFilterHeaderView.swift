//
//  ERSideFilterHeaderView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 21/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol ERSideFilterHeaderViewDelegate {
    func expandCollapse(objERFilterTag : ERFilterTag,isExpand : Bool)
}



class ERSideFilterHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var btnExpand: UIButton!
    var objERFilterTag : ERFilterTag!
    var delegate : ERSideFilterHeaderViewDelegate!
    
    @IBAction func btnExpandTapped(_ sender: Any) {
        objERFilterTag.isExpand = !objERFilterTag.isExpand
        delegate.expandCollapse(objERFilterTag: objERFilterTag, isExpand: objERFilterTag.isExpand)
        if objERFilterTag.isExpand  {
            btnExpand.setImage(UIImage.init(named: "dropdown"), for: .normal);
        }
        else{
            btnExpand.setImage(UIImage.init(named: "dropdown"), for: .normal);
        }
    }
    
    func customizeHeaderView(){
        
        
        viewContainer.backgroundColor = ILColor.color(index: 22)
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        {
            UILabel.labelUIHandling(label: lblCategoryName, text: objERFilterTag.categoryTitle ?? "", textColor:ILColor.color(index: 42) , isBold: false, fontType: fontHeavy)
        }

        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)

        if objERFilterTag.isExpand  {
            btnExpand.setImage(UIImage.init(named: "Drop-down_arrow"), for: .normal);
        }
        else{
            btnExpand.setImage(UIImage.init(named: "Drop-down_arrow"), for: .normal);
        }
    }
    
}
