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
    var arrImage = [String]();
    var arrName = [String]();
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
//        self.createBezierPath()
        tblview.separatorStyle = .none
        
        self.profileUpdate()
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            arrImage = ["user","noun_schedule_3370222","noun_logout_1153738-2"];
             arrName = ["Profile", "Scheduled Appointments","Logout"];
        }
        else
        {
            arrImage = ["user","noun_schedule_3370222","noun_schedule_694983","blackDateIcon",  "noun_logout_1153738-2"];
             arrName = ["Profile", "Scheduled Appointments","Set Advising Appointment Hour","Add Blackout Date","Logout"];
        }
        tblview.reloadData()

        
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
        
        
        

        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        if let lastName = UserDefaults.standard.object(forKey: "lastName") {
            
                UILabel.labelUIHandling(label: nameLabel, text: "\(firstName) \(lastName)", textColor: ILColor.color(index: 62), isBold: false, fontType: fontHeavy)
            
        }else{
            nameLabel.text = "\(firstName)"
            UILabel.labelUIHandling(label: nameLabel, text: "\(firstName)", textColor: ILColor.color(index: 62), isBold: false, fontType: fontHeavy)

        }

        UILabel.labelUIHandling(label: emailLabel, text: UserDefaults.standard.object(forKey: "userEmail") as? String ?? "", textColor: ILColor.color(index: 62), isBold: false, fontType: fontBook)

        activityIndicator.startAnimating()
        profilePictureImageView.cornerRadius = profilePictureImageView .frame.width / 2
        
        if let profUrl = profileUrl, let url = URL(string: profUrl) {
            profilePictureImageView.setImageWith(URLRequest.init(url: url), placeholderImage:  UIImage.init(named: "ProfileBG")) { urlrest, response, image in
                self.profilePictureImageView.image = image
            } failure: { urlrest, response, error in
                
            }
           
        }else{
            self.profilePictureImageView.image = UIImage.init(named: "ProfileBG")
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
        case 1:
            
            let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
            if isStudent ?? false {
                delegateRedirection.redirectToParticularViewController(type: .coachSelection)
            }
            else
            {
                delegateRedirection.redirectToParticularViewController(type: .adhoc)
            }
            
        case 2:
            
            let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
            if isStudent ?? false {
                delegateRedirection.redirectToParticularViewController(type: .logOut)
            }
            else
            {
                delegateRedirection.redirectToParticularViewController(type: .setAppo)
            }
            
        case 3:
            delegateRedirection.redirectToParticularViewController(type: .blackout)
        case 4:
            delegateRedirection.redirectToParticularViewController(type: .logOut)

            
        default:
            delegateRedirection.redirectToParticularViewController(type: .profile)
        }
        
    }
    
}
