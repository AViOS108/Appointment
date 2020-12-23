//
//  ErSideCalenderCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ErSideCalenderCollectionViewCellDelegate {
    
    func datechanged(modalCalender : ERSideCalender)
    
}






class ErSideCalenderCollectionViewCell: UICollectionViewCell {
     
    
    @IBAction func btnDateSelectedTapped(_ sender: UIButton) {
        if self.modalCalender.isClickable{
            delegate.datechanged(modalCalender: self.modalCalender)
        }
    }
    
    var delegate : ErSideCalenderCollectionViewCellDelegate!
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    var modalCalender : ERSideCalender!
    
    
    
    
    func customize()  {
        
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let day = modalCalender.dateC.get(.day)
        let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        let dayI = modalCalender.dateC.get(.weekday)
        UILabel.labelUIHandling(label: lblDay, text: "\(weekDay[dayI - 1])" , textColor: ILColor.color(index: 25), isBold: false, fontType: fontBook)
        
        if modalCalender.isSelected {
            lblDate.layoutIfNeeded()

            UILabel.labelUIHandling(label: lblDate, text: "\(day)", textColor: .white, isBold: false, fontType: fontHeavy,  backgroundColor: ILColor.color(index: 45))
            lblDate.cornerRadius = 14
        }
        else{
            lblDate.layoutIfNeeded()
            lblDate.backgroundColor = .clear
            lblDate.cornerRadius = 0;
            UILabel.labelUIHandling(label: lblDate, text: "\(day)", textColor: ILColor.color(index: 26), isBold: false, fontType: fontHeavy)
        }

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
