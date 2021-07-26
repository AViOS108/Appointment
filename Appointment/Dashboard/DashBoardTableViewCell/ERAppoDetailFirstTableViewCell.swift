//
//  ERAppoDetailFirstTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 01/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERAppoDetailFirstTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCollection: ERSideFIrstTypeCollectionView!
    var viewController : UIViewController!
    var appoinmentDetailAllModalObj: ApooinmentDetailAllNewModal?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func customization() {
        self.backgroundColor = ILColor.color(index: 22)

        viewCollection.register(UINib.init(nibName: "ERSideAppoDetailTypeFirstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ERSideAppoDetailTypeFirstCollectionViewCell")
        viewCollection.viewController = self.viewController
        viewCollection.delegateI = self.viewController as! ERSideFIrstTypeCollectionViewDelegate
        viewCollection.appoinmentDetailAllModalObj = self.appoinmentDetailAllModalObj
        viewCollection.customize()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
