//
//  SliderTableViewCell.swift
//  Event
//
//  Created by Anurag Bhakuni on 19/06/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSlider: UIImageView!
    @IBOutlet weak var lblSlider: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func  customize(txtSlider : String, imgSlider : String)  {
        
        if let FontDemiBold = UIFont(name: "FontDemiBold".localized(), size: Device.FONTSIZETYPE13)
        {
            UILabel.labelUIHandling(label: lblSlider, text: txtSlider, textColor: ILColor.color(index: 4), isBold: false, fontType: FontDemiBold)
        }
        self.imgSlider.image = UIImage.init(named: imgSlider)
        self.imgSlider.contentMode = .center
    }
    
    
    
    
}
