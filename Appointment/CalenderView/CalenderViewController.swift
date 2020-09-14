//
//  CalenderViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 21/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class CalenderViewController: UIViewController {
    
    var pointSign : CGPoint?
    var viewControllerI : UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let myView = Bundle.loadView(fromNib: "CalenderView", withType: CalenderView.self)
        myView.frame = CGRect.init(x: 0, y: abs(pointSign!.y), width: self.view.frame.width, height: self.view.frame.height-abs(pointSign!.y));
        myView.viewControllerI = self
        myView.pointSign = pointSign
        myView.delegate = (viewControllerI as! CalenderViewDelegate)
        
        myView.customize()
        //        myView.bringSubviewToFront( self.view)
        self.view.addSubview(myView);
        
        self.view.backgroundColor =  UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        //        view.isOpaque = false
        
    }
    
}
