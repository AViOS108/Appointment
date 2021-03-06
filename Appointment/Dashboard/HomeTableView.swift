//
//  HomeTableView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 18/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class HomeTableView: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var viewControllerI : HomeViewController!
    //    var modalEvent : EventModal?
    var totalCount : Int?
    //    var callbackVC: ((_ indePath : BtnInterestedGoing) -> Void)?
    var nocoach = false,noAlumini = false
    
    func customization()  {
        viewControllerI.tblView.delegate = self
        viewControllerI.tblView.dataSource = self
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
        viewControllerI.tblView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachListingTableViewCell", for: indexPath) as! CoachListingTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = viewControllerI as? CoachListingTableViewCellDelegate
        if indexPath.section == 0
        {
            if nocoach {
                
            }
            else
            {
                cell.coachModal = (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "career_coach"
                    
                    })![indexPath.row];
                
            }
            cell.customization(noCoach: nocoach, text: "No Coach Found !")
        }
        else{
            
            if noAlumini {
                
            }
            else
            {
                cell.coachModal = (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "external_coach"
                    })![indexPath.row];
                
            }
            cell.customization(noCoach: noAlumini, text: "No Alumini Found !")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            
            if nocoach == true
            {
                return 1
            }
            
            
            if (viewControllerI.dataFeedingModal?.sectionHeader![section].seeAll)!
            {
                return (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "career_coach"
                    })!.count
            }
            else
            {
                if (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "career_coach"
                    })!.count < 2
                {
                    return (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "career_coach"
                        })!.count
                }
                else{
                    return 2
                    
                }
            }
        }
        else
        {
            if noAlumini == true
            {
                return 1
            }
            
            
            if (viewControllerI.dataFeedingModal?.sectionHeader![section].seeAll)!
            {
                return (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "external_coach"
                    })!.count
            }
            else
            {
                if (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "external_coach"
                    })!.count < 2
                {
                    return (viewControllerI.dataFeedingModal?.coaches.filter{ $0.roleMachineName.rawValue == "external_coach"
                        })!.count
                }
                else{
                    return 2
                    
                }            }
        }
    }
    
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var coachModal = viewControllerI.dataFeedingModal?.coaches[indexPath.row];
        coachModal?.isSelected = true
        viewControllerI.dataFeedingModal?.coaches.remove(at: indexPath.row)
        viewControllerI.dataFeedingModal?.coaches.insert(coachModal!, at: indexPath.row)
        viewControllerI.redirection(redirectionType: .coachSelection)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderSectionCoach") as! HeaderSectionCoach
        headerView.delegate = viewControllerI as? HeaderSectionCoachDelegate
        headerView.sectionHeader = viewControllerI.dataFeedingModal?.sectionHeader![section];
        headerView.customization()
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
}
