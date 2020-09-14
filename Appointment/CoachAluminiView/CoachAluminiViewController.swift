//
//  CoachAluminiViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 25/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol CoachAluminiViewControllerDelegate: AnyObject {
  func reloadCollectionView()
    
    
}



class CoachAluminiViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var viewFooterBtnCoach: UIView!
    @IBOutlet weak var viewFooterBtnAlumini: UIView!
    var delegate :CoachAluminiViewControllerDelegate!
    @IBOutlet weak var nslayoutConstraintTop: NSLayoutConstraint!
    
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var viewOuter: UIView!
    
    var pointSign : CGPoint?
    var nocoach = false,noAlumini = false
    var viewControllerI : CoachSelectionViewController!
    @IBOutlet weak var tblVIew: UITableView!
    @IBOutlet weak var btnCoach: UIButton!
    var isCoachSelected = true
    
    @IBAction func btncoachtapped(_ sender: Any) {
        isCoachSelected = true
        let FontDemiBold = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
        UIButton.buttonUIHandling(button: btnCoach, text: "Coaches", backgroundColor:.white , textColor: ILColor.color(index: 23), cornerRadius: 5, isUnderlined: false, fontType: FontDemiBold)
        UIButton.buttonUIHandling(button: btnAlumini, text: "Alumini", backgroundColor:.white , textColor: ILColor.color(index: 28), cornerRadius: 5, isUnderlined: false, fontType: FontDemiBold)
        viewFooterBtnCoach.backgroundColor = ILColor.color(index: 23)
        viewFooterBtnAlumini.backgroundColor = ILColor.color(index: 22)

        self.tblVIew.reloadData()
        
    }
    
    @IBOutlet weak var btnAlumini: UIButton!
    
    @IBAction func btnAluminiTapped(_ sender: Any) {
        isCoachSelected = false
        let FontDemiBold = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
        UIButton.buttonUIHandling(button: btnCoach, text: "Coaches", backgroundColor:.white , textColor: ILColor.color(index: 28), cornerRadius: 5, isUnderlined: false, fontType: FontDemiBold)
        UIButton.buttonUIHandling(button: btnAlumini, text: "Alumini", backgroundColor:.white , textColor: ILColor.color(index: 23), cornerRadius: 5, isUnderlined: false, fontType: FontDemiBold)
        viewFooterBtnCoach.backgroundColor = ILColor.color(index: 22)
        viewFooterBtnAlumini.backgroundColor = ILColor.color(index: 23)
        
        self.tblVIew.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        tblVIew.register(UINib.init(nibName: "CoachAluminiSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CoachAluminiSelectionTableViewCell")

        // Do any additional setup after loading the view.
    }
    
    func customize()  {
        self.tblVIew.reloadData()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.tag = 19682
        
        if let FontDemiBold = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
        {
            UIButton.buttonUIHandling(button: btnCoach, text: "Coaches", backgroundColor:.white , textColor: ILColor.color(index: 23), cornerRadius: 5, isUnderlined: false, fontType: FontDemiBold)
            
            UIButton.buttonUIHandling(button: btnAlumini, text: "Alumini", backgroundColor:.white , textColor: ILColor.color(index: 28), cornerRadius: 5, isUnderlined: false, fontType: FontDemiBold)
            
            viewFooterBtnCoach.backgroundColor = ILColor.color(index: 23)
            viewFooterBtnAlumini.backgroundColor = ILColor.color(index: 22)
            
        }
        
        if (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "career_coach"
            })!.count == 0
        {
            nocoach = true
        }
        else
        {
            nocoach = false
            
        }
        
        if (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "external_coach"
            })!.count == 0
        {
            noAlumini = true
        }
        else{
            noAlumini = false
            
        }
        
        
        
        nslayoutConstraintTop.constant = pointSign?.y as! CGFloat
        drawArrowFromPoint()
        tapGesture()
        
        // corner radius
        viewOuter.layer.cornerRadius = 10
        
        // border
        viewOuter.layer.borderWidth = 1.0
        viewOuter.layer.borderColor = ILColor.color(index: 27).cgColor
        
        // shadow
        viewOuter.layer.shadowColor = ILColor.color(index: 27).cgColor
        viewOuter.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewOuter.layer.shadowOpacity = 0.7
        viewOuter.layer.shadowRadius = 4.0
        viewOuter.clipsToBounds = true
        viewOuter.layer.masksToBounds = true
    }
    
    func tapGesture()  {
             let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
             tap.delegate = self
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
         }
      
    @objc func handleTap(_ sender: UITapGestureRecognizer) {

          viewControllerI!.dismiss(animated: false) {
            
            self.delegate.reloadCollectionView()
            }

         }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682  {
                  return false
               }
               return true
          }
       
    
    
    
    func drawArrowFromPoint() {
        //design the path
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: abs(self.pointSign!.x) - 10 , y: 21 + pointSign!.y))
        path.addLine(to: CGPoint.init(x: abs(self.pointSign!.x) , y: 0 + pointSign!.y))
        path.addLine(to: CGPoint.init(x: abs(self.pointSign!.x) + 10, y: 21 + pointSign!.y))
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        // border
        shapeLayer.borderWidth = 1.0
        shapeLayer.borderColor = ILColor.color(index: 27).cgColor
        self.view.layer.addSublayer(shapeLayer)
    }
}

extension CoachAluminiViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachAluminiSelectionTableViewCell", for: indexPath) as! CoachAluminiSelectionTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        //           cell.delegate = viewControllerI as? CoachListingTableViewCellDelegate
        if isCoachSelected
        {
            if nocoach {
            }
            else
            {
                    cell.coachModal = (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "career_coach"
                        })![indexPath.row ];
                
            }
            cell.delegate = viewControllerI
            cell.customization(noCoach: nocoach, text: "No Coach Found !", row: indexPath.row)
        }
        else{
            if noAlumini {
            }
            else
            {
                
                    cell.coachModal = (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "external_coach"
                        })![indexPath.row ];
            }
            cell.customization(noCoach: noAlumini, text: "No Alumini Found !", row: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCoachSelected
        {
            if nocoach == true
            {
                return 1
            }
            else
            {
                return (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "career_coach"
                    })!.count
            }
        }
        else
        {
            if noAlumini == true
            {
                return 1
            }
                
            else{
                return (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "external_coach"
                    })!.count
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
}



