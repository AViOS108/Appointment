//
//  ERSideResumeListViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 12/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

enum  ERSideResumeListTaskProvidedBycell{
    case view
    case download
    case print
}



class ERSideResumeListViewController: SuperViewController {

    @IBOutlet weak var tblView: UITableView!
    var results: ERSideAppointmentModalNewResult!
    var activityIndicator: ActivityIndicatorView?

    var objERSideResumeListModal : ERSideResumeListModal!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModal()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        customization()
    }

    func customization(){
        tblView.register(UINib.init(nibName: "ERSideResumeListTableViewCell", bundle: nil), forCellReuseIdentifier: "ERSideResumeListTableViewCell")
        tblView.dataSource = self
        tblView.delegate = self
        self.view.backgroundColor = ILColor.color(index: 22)

        tblView.separatorStyle = .none
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Candidate Resume ")
    }

    override func buttonClicked(sender: UIBarButtonItem) {
          self.navigationController?.popViewController(animated: true)
      }
    
    
    func viewModal() {
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)

        let include = ["rp_latest_resume_id","rp_latest_resume_score","rp_latest_resume_score_type","rp_first_resume_id","rp_first_resume_score","rp_first_resume_score_type","rp_highest_scored_resume_id","rp_highest_scored_resume_score","rp_highest_scored_resume_score_type","rp_summary","invitation_id","benchmark","tags"]
        
        var invitationIDs = Array<Int>()
        
        for request in self.results.requests!{
            let invitationID = request.studentID
            invitationIDs.append(invitationID ?? 0);
            
        }
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String

        let params = ["includes" : include,
                      "_method":"post",
                      ParamName.PARAMFILTERSEL:["invite_ids":invitationIDs],
                      ParamName.PARAMCSRFTOKEN : csrftoken

            ] as [String : AnyObject]
        
        ERSideAppointmentService().erSideResumeList(params: params, { (data) in
            self.activityIndicator?.hide()
            
            do {
                self.objERSideResumeListModal = try JSONDecoder().decode(ERSideResumeListModal.self, from: data)
                self.tblView.reloadData()
            } catch  {
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)            }
            
            
        }) { (strMessage, strCode) in
            
        }
    }
    
    
}


extension ERSideResumeListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERSideResumeListTableViewCell", for: indexPath) as! ERSideResumeListTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self;
        cell.objERSideResumeListModalItem = self.objERSideResumeListModal.items![indexPath.row]
        cell.customization()
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.objERSideResumeListModal != nil
        {
            return self.objERSideResumeListModal.items?.count ?? 0
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
    }
    
}

extension ERSideResumeListViewController : ERSideResumeListTableViewCellDelegate{
    
    func taskProvidedToVC(taskType: ERSideResumeListTaskProvidedBycell, resumeID: Int) {
        if taskType == .view{
            apitHitForResumeView(resumeID: resumeID)
        }
        else if taskType == .download{
            apitHitForDownloadResume(resumeID: resumeID)
        }
        else{
            apitHitForPrintResume(resumeID: resumeID)

        }
    }
    
    
    func apitHitForPrintResume(resumeID: Int){
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        
        ERSideAppointmentService().erSideResumeView(resumeId: resumeID,{ (data) in
            self.activityIndicator?.hide()

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    self.openWebView(url: json["\(resumeID)"] as! String)
                   }
                
            } catch  {
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
            
        }) {
            (error, errorCode) in
            self.activityIndicator?.hide()
        };
        
    }
    
    
    
    
    func apitHitForDownloadResume(resumeID: Int){
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        
        ERSideAppointmentService().erSideResumeView(resumeId: resumeID,{ (data) in
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.downloadResume(url: json["\(resumeID)"] as! String)
                   }
                
            } catch  {
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
            
            
        }) {
            (error, errorCode) in
            self.activityIndicator?.hide()
        };
        
    }
    
    func downloadResume(url:String){
        
        ERSideAppointmentService().erSideDownloadResume(url: url) { (data) in
            self.activityIndicator?.hide()
            let destinationFileUrl  = data["destinationUrl"] as! URL;
            
            do {
                
                let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
                do {
                    let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                    for indexx in 0..<contents.count {
                        if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                            let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                            self.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }
                catch (let err) {
                    print("error: \(err)")
                }
            } catch (let writeError) {
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
            }
            
            
        } failure: { (error, errorCode) in
            self.activityIndicator?.hide()

        }

        
       
    }
    
    
    func apitHitForResumeView(resumeID: Int){
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        
        ERSideAppointmentService().erSideResumeView(resumeId: resumeID,{ (data) in
            self.activityIndicator?.hide()
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.openWebView(url: json["\(resumeID)"] as! String)
                   }
                
            } catch  {
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
            
            
        }) {
            (error, errorCode) in
            self.activityIndicator?.hide()
        };
        
    }
    
    func openWebView(url:String){
        let wvc = UIStoryboard.webViewer()
        wvc.webUrl =  url
        self.navigationController?.pushViewController(wvc, animated: true)
    }
    
}



