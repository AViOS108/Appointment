//
//  CoachSelectionViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 26/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class CoachSelectionViewController: SuperViewController {
    var dataFeedingModal : DashBoardModel?
    var selectedDataFeedingModal : DashBoardModel?
    var colectionViewHandler = CoachImageOverlayView();
    @IBOutlet weak var viewCollection: UICollectionView!
    
    var coachAluminiViewController : CoachAluminiViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        GeneralUtility.customeNavigationBarWithBack(viewController: self,title:"Schedule");

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        colectionViewHandler.selectedDataFeedingModal = self.selectedDataFeedingModal
        colectionViewHandler.viewCollection = self.viewCollection
        colectionViewHandler.customize();
    }
    override func viewDidAppear(_ animated: Bool) {
        let coachCarrerCoach = Coach.init(id: -1, name: "Selecte All", email: "", profilePicURL: "", summary: "", headline: "", roleID: -1, roleMachineName: .careerCoach, requestedResumes: nil,isSelected: false)
        let coachExternalCoach = Coach.init(id: -1, name: "Selecte All", email: "", profilePicURL: "", summary: "", headline: "", roleID: -1, roleMachineName: .externalCoach, requestedResumes: nil,isSelected: false)
        self.dataFeedingModal?.coaches.insert(coachCarrerCoach, at: 0)
        self.dataFeedingModal?.coaches.insert(coachExternalCoach, at: 0)
    }
    
    
    override  func calenderClicked(sender: UIButton) {
        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        
        coachAluminiViewController = CoachAluminiViewController.init(nibName: "CoachAluminiViewController", bundle: nil)
        coachAluminiViewController.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        coachAluminiViewController.viewControllerI = self
        coachAluminiViewController.modalPresentationStyle = .overFullScreen
        self.present(coachAluminiViewController, animated: false) {
        }
    }
   override func buttonClicked(sender: UIBarButtonItem) {

    self.navigationController?.popViewController(animated: false)
    
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
extension CoachSelectionViewController:CoachAluminiSelectionTableViewCellDelegate{
    
    func changeModal(modal: Coach, row: Int) {
    
        if row == 0
        {
            var coachArr = [Coach]()
            let selectedCoach =   self.dataFeedingModal?.coaches
            for var coaches in selectedCoach!{
                if coaches.roleMachineName.rawValue == modal.roleMachineName.rawValue{
                    coaches.isSelected = !modal.isSelected
                }
                else
                {
                    coaches.isSelected = false
                }
                coachArr.append(coaches);
            }
            self.dataFeedingModal?.coaches.removeAll()
            self.dataFeedingModal?.coaches.append(contentsOf: coachArr);
            
        }
        else
        {
            
            var coachArr = [Coach]()
            let selectedRemovePrevious =   self.dataFeedingModal?.coaches.filter{
             $0.roleMachineName.rawValue != modal.roleMachineName.rawValue
             };
            
            for var coaches in selectedRemovePrevious!{
                coaches.isSelected = false
                coachArr.append(coaches);
            }
            
            
            self.dataFeedingModal?.coaches.removeAll(where: {
                $0.roleMachineName.rawValue != modal.roleMachineName.rawValue
            })
            
            self.dataFeedingModal?.coaches.append(contentsOf: coachArr);

            
            let index = self.dataFeedingModal?.coaches.firstIndex(where: {$0.id == modal.id})
            var selectedCoach =   self.dataFeedingModal?.coaches.filter{
                $0.id == modal.id
                }[0];
            let selectedCoachI = selectedCoach;
            selectedCoach?.isSelected = !selectedCoachI!.isSelected
            
            self.dataFeedingModal?.coaches.remove(at: index!)
            self.dataFeedingModal?.coaches.insert(selectedCoach!, at: index!)
            
            
        }
        coachAluminiViewController.customize()
        
    }
}
