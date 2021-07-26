//
//  DemoViewController.swift
//  Event
//
//  Created by Anurag Bhakuni on 13/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("s")

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        print("4")
        self.lbl.text = "ds"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("6")

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
