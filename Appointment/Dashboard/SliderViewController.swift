//
//  SliderViewController.swift
//  Event
//
//  Created by Anurag Bhakuni on 14/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

protocol HomeViewcontrollerRedirection {
    
    func redirectToParticularViewController(type : RedirectionType)
        
}


class SliderViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var tblview: UITableView!
    var arrImage = ["my event black","my event black","my event black"];
    var arrName = ["Profile", "My Event","History"];
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var delegateRedirection : HomeViewcontrollerRedirection!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    var activityLoader: ActivityIndicatorView?
    var profileUrl: String?
    var path : UIBezierPath?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
                self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        self.view.backgroundColor = .white
        self.createBezierPath()
        tblview.separatorStyle = .none
        
        self.profileUpdate()
    }
    
    func createBezierPath() {
        
        if path == nil
        {
            path = UIBezierPath();
            let p1 = CGPoint.init(x: 0, y: 0)
            let p2 = CGPoint.init(x: 0, y: viewInfo.frame.height)
            let p3 = CGPoint.init(x:viewInfo.frame.width/2 - 20,y:viewInfo.frame.height)
            let p4 = CGPoint.init(x:viewInfo.frame.width,y: 0.5 * viewInfo.frame.height)
            let p5 = CGPoint.init(x:viewInfo.frame.width,y:0)
            path!.move(to: p1)
            path!.addLine(to: p2)
            path!.addLine(to: p3)
            path!.addQuadCurve(to: p4, controlPoint: CGPoint(x: viewInfo.frame.width , y: viewInfo.frame.height ))
            path!.addLine(to: p5)
            let line = CAShapeLayer()
            line.path = path?.cgPath;
            line.fillColor = ILColor.color(index: 7).cgColor
            line.lineWidth = 3.0
            viewInfo.layer.addSublayer(line)
            line.zPosition = -1;
        }
        
        
    }
    
    
    
    func profileUpdate(){
        profileUrl = UserDefaults.standard.value(forKey: "userProfile") as? String
        var firstName = ""
        if let fn = UserDefaults.standard.object(forKey: "firstName"){
            firstName = fn as! String
        }

        if let lastName = UserDefaults.standard.object(forKey: "lastName") {
            nameLabel.text = "\(firstName) \(lastName)"
        }else{
            nameLabel.text = "\(firstName)"
        }
        emailLabel.text = UserDefaults.standard.object(forKey: "userEmail") as? String

        activityIndicator.startAnimating()
        if let profUrl = profileUrl, let url = URL(string: profUrl) {

//            profilePictureImageView.setImageWith(URLRequest.init(url: url), placeholderImage: #imageLiteral(resourceName: "avatar"), success: { (urlrequest, respone, image) in
//                self.profilePictureImageView.image = image;
//
//            }) { (urlrequest, respone, error) in
//
//            }

        }else{
//            self.profilePictureImageView.image = #imageLiteral(resourceName: "avatar")
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tblview.delegate = self
        tblview.dataSource = self
        tblview.register(UINib.init(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "SliderTableViewCell")
    }
    // MARK: - Tablview Datasource and delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SliderTableViewCell", for: indexPath) as! SliderTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.customize(txtSlider: arrName[indexPath.row], imgSlider: arrImage[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count ;
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            delegateRedirection.redirectToParticularViewController(type: .profile)

        default:
            delegateRedirection.redirectToParticularViewController(type: .profile)

        }
        
    }
    
}
