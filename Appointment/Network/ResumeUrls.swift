//
//  ResumeUrls.swift
//  Resume
//
//  Created by VM User on 31/01/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation

class Urls {
    static let testHost = "dashboard-test.vmock.com"
    static let stagingHost = "dashboard-staging.vmock.com"
    static let liveHost = "www.vmock.com"
    
    static let testEnv = "https://api-dboard-test.vmock.com/"
    static let stagingEnv = "https://api-dboard-staging.vmock.com/"
    static let liveEnv = "https://api-dashboard.vmock.com/"
    
    static let testEnvJobs = "https://jobsdev.vmock.com/"
    static let stagingEnvJobs = "https://api-scm-staging.vmock.com/"
    static let liveEnvJobs = "https://api-scm.vmock.com/"
    
    static let devEnvEvents = "https://employerdev.vmock.com/khagesh/api/calendar-management/public/"
    static let testEnvEvents = "https://employerdev.vmock.com/khagesh/api/test-calendar-management/public/"
    
    static let stagingEnvEvents = "https://api-employer-staging.vmock.com/calendar-management/"
    static let liveEnvEvents = "https://api-employer.vmock.com/calendar-management/"
    
    
    static let devStudentList = "https://employerdev.vmock.com/khagesh/api/test-student-view/public/"
 
    static let stagingStudentList = "https://employerdev.vmock.com/khagesh/api/test-student-view/public/"

    static let liveStudentList = "https://employerdev.vmock.com/khagesh/api/test-student-view/public/"

       
    static let devRoleList = "https://employerdev.vmock.com/khagesh/api/test-community-user-management/public/"
    
       static let stagingRoleList = "https://employerdev.vmock.com/khagesh/api/test-student-view/public/"

       static let liveRoleList = "https://employerdev.vmock.com/khagesh/api/test-student-view/public/"
  
    static let devResumeView =   "https://employerdev.vmock.com/khagesh/api/test-resume-management/public/"
    static let stagingResumeView =   "https://employerdev.vmock.com/khagesh/api/test-resume-management/public/"
    static let liveResumeView =   "https://employerdev.vmock.com/khagesh/api/test-resume-management/public/"

    
    static let testShareEvents = "https://temp3.vmock.com/dashboard/events/my-events"
    static let stagingShareEvents = "https://dashboard-staging.vmock.com/dashboard/events/my-events"
    static let liveShareEvents = "https://vmock.com/dashboard/events/my-events"
    
    
    static let testEnvNotes = "https://employerdev.vmock.com/khagesh/api/test-notes/public/"
    
    
    
    
    #if DEVELOPMENT
    static let runningEnv = testEnv
    static let runningHost = testHost
    static let runningEnvJobs = testEnvJobs
    static let runningEnvEvents = testEnvEvents
    static let SharingEvents = testShareEvents
    static let runningEnvNotes = testEnvNotes
    
    static let runningEnvStudentList = devStudentList

    static let runningEnvRoleList = devRoleList
    static let runningEnvResumeView = devResumeView

    
    #else
    
    static let runningEnv = testEnv
    static let runningHost = testHost
    static let runningEnvJobs = testEnvJobs
    static let runningEnvEvents = testEnvEvents
    static let SharingEvents = testShareEvents
    static let runningEnvNotes = testEnvNotes
    
    static let runningEnvStudentList = devStudentList
    static let runningEnvRoleList = devRoleList
    static let runningEnvResumeView = devResumeView

    
    //        static let runningEnv = liveEnv
    //        static let runningHost = liveHost
    //        static let runningEnvJobs = liveEnvJobs
    //        static let runningEnvEvents = liveEnvEvents
    //        static let SharingEvents = liveShareEvents
    #endif
    
    //    var type1 = "\(devEnv)ravindra2/dashboard/accounts/public/api/v1/"
    //    var type2 = "\(devEnv)geetika/api-network-feedback/public/v1/"
    //    var type3 = "\(devEnv)geetika/dashboard-api-resume-parser/public/v1/"
    //    var type4 = "\(devEnv)geetika/analytics/public/v1/"
    
    var type1 = "\(runningEnv)accounts/api/v1/"
    var type2 = "\(runningEnv)nf/v1/"
    var type3 = "\(runningEnv)rp/v1/resume/mobile/"
    var type4 = "\(runningEnv)r-analytics/v1/"
    var type5 = "\(runningEnv)cf-notes/v1/"
    var type6 = "\(runningEnv)tracking/"
    var type7 = "\(runningEnv)survey/v1/"
    
    var type8 = "\(runningEnvStudentList)api/v1/"

    var type9 = "\(runningEnvRoleList)api/v1/"
    var type10 = "\(runningEnvResumeView)api/v1/"


    var typeJob1 = "\(runningEnvJobs)ats/api/v1/"
    var typeJob2 = "\(runningEnvJobs)relationship-management/api/v1/"
    
    
    var privacyPolicy = "https://www.vmock.com/pages/privacy_policy.php"
    var terms = "https://www.vmock.com/pages/terms_and_conditions.php"
    var blog = "https://blog.vmock.com/"
    
    
    
    var typeEvent1 = "\(runningEnvEvents)api/v1/"
    var typeEvent2 = "\(runningEnvEvents)api/v2/"
    
    var ErLoginType1 = "\(runningEnvJobs)accounts/api/v2/"
    var ErLoginType2 = "\(runningEnvJobs)accounts/api/v1/"
    
    
    
    
    
    // Login
    //MARK: TYPE 1
    func getCommunityList() -> String {
        return "\(type1)mobile/communities"
    }
    
    func getProviderDetails(link: String) -> String{
        return "\(type1)registration/providers?link=\(link)"
    }
    
    func checkLoginStatus() -> String {
        return "\(type1)registration/status"
    }
    
    func login() -> String{
        return "\(type1)login/common"
    }
    
    func resendVerification() -> String{
        return "\(type1)verification/send"
    }
    
    func resgister() -> String{
        return "\(type1)registration/register"
    }
    
    func forgotPassword() -> String {
        return "\(type1)password/email"
    }
    
    func getNewCaptch() -> String {
        return "\(type1)captcha/new"
    }
    
    func getAccountDetails() -> String{
        return "\(type1)account/details/fields?response_type=array"
    }
    
    func getAccountDetailsOption(id: String) -> String{
        return "\(type1)account/details/fields/options?\(id)"
    }
    
    
    func updateAccountDetails() -> String{
        return "\(type1)account/details"
    }
    
    func resetPassword() -> String {
        return "\(type1)password/reset"
    }
    
    func verifyAccount() -> String {
        return "\(type1)verification/verify"
    }
    func referralsInfo() -> String {
        return "\(type1)referrals/info"
    }
    
    func getUserInfo() -> String {
        return "\(type1)user/info"
    }
    
    func getCustomizationUrl() -> String {
        return "\(type1)user/customizations"
    }
    
    func updateProfile() -> String {
        return "\(type1)profile/name"
    }
    
    func updatePassword() -> String {
        return "\(ErLoginType1)password/change"
    }
    
    func getPaymentDetails() -> String{
        return "\(type1)payments/button"
    }
    
    func paypalPaymentVerify() -> String{
        return "\(type1)payments/paypal/verify"
    }
    
    func ccavanuePaymentVerify() -> String{
        return "\(type1)payments/ccavenue/verify"
    }
    
    
    func coachListStudentSide() -> String{
        return "\(type9)student/career_services/members/appointments"
    }
    
    func uploadProfilePicture() -> String{
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false
        {
            return "\(type1)profile/photo"
        }
        else
        {
            return "\(type9)users/me/profile_picture"
        }
    }
    
    func updateProfileNew() -> String{
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false
        {
            return "\(type1)users/me"
        }
        else
        {
            return "\(type9)users/me"
        }
    }
    
    func verifyPayment(provider: String) -> String{
        return "\(type1)payments/\(provider)/verify"
    }
    
    func getOrders() -> String{
        return "\(type1)payments/orders"
    }
    
    func sync() -> String {
        return "\(type1)account/sync"
    }
    
    func agreement() -> String {
        return "\(type1)account/agreement"
    }
    
    
    //MARK: TYPE 4
    
    func analyticsData() -> String {
        return"\(type4)analytics/data"
    }
    
    //MARK: TYPE 5
    func notes() -> String {
        return "\(type5)notes"
    }
    func tags() -> String {
        return "\(type5)tags"
    }
    func tasks() -> String {
        return "\(type5)tasks"
    }
    
    // Tracking
    //MARK: TYPE 6
    
    func tracking() -> String {
        return "\(type6)resume"
    }
    
    
    func shareUrl(idEvent : String) -> String  {
        return "\(Urls.SharingEvents)?id=\(idEvent)"
    }
    
    
    
    //MARK: Event List
    
    func coachesList() -> String {
        
        guard UserDefaultsDataSource(key: "csrf_token").readData() != nil else {
            return ""
        }
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        
        
        if isStudent ?? false
        {
            return "\(type2)feedback/resume/networks"
            
        }
        else
        {
            return "\(typeEvent1)community/events/list?csrf_token=\(csrftoken)"
            
        }
        
    }
    
    
    func timezoneList() -> String {
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false
        {
            return "\(typeEvent1)students/events/timezones"
        }
        else{
            return "\(typeEvent1)community/events/timezones"
            
            
        }
        
        
        
    }
    
    func openHourCCList() -> String {
        return "\(typeEvent2)students/appointments/list"
        
    }
    
    func openHourCCList2() -> String {
        return "\(typeEvent2)students/open-hour/list"
        
    }
    
    func openHourECList() -> String {
        return "\(typeEvent1)students/external-appointment-slots"
        
    }
    
    func confirmAppointment(id:String) -> String {
        
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false
        {
            
            return "\(typeEvent2)students/appointments/" + id
            
        }
        else
        {
            return "\(typeEvent2)community/appointments/" + id
            
        }
        
    }
    
    
    func coachDetail(id:String) -> String {
        
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false
        {
            
            return "\(type9)student/career_services/coach-details/" + id
            
        }
        else
        {
            return "\(type9)student/career_services/coach-details/" + id

        }
        
    }
    
    func nextStepAppointment(id:String) -> String {
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false
        {
            return "\(typeEvent2)students/appointments/" + id + "/next-steps"
        }
        else
        {
            return "\(typeEvent2)community/appointment-next-steps"

        }
    }
    
    func notesAppointment(id:String,isShared:String) -> String {
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false
        {
            return "\(Urls.runningEnvNotes)api/v1/student/notes/list?filters[attachable_entities][0][entity_id]=\(id)&filters[attachable_entities][0][entity_type]=appointment&filters[is_shared]=\(isShared)"
        }
        else
        {
            return "\(Urls.runningEnvNotes)api/v1/community/notes/list?filters[attachable_entities][0][entity_id]=\(id)&filters[attachable_entities][0][entity_type]=appointment&filters[is_shared]=\(isShared)"
        }
        
    }
    
    
    
    func eventErChalleges(stringEmail:String) -> String {
        return "\(ErLoginType1)auth/login/challenges?email=\(stringEmail)"
        
    }
    
    func eventErLogin(stringEmail:String,strPwd:String) -> String {
        //              return "\(ErLoginType1)auth/login?email=\(stringEmail)&password=\(strPwd)"
        return "\(ErLoginType1)auth/login"
        
    }
    
    func eventErAuth() -> String {
        return "\(ErLoginType2)auth/login"
        
    }
    
    func getNewCaptchEr() -> String {
        return "\(ErLoginType2)captcha/new"
    }
    
    func extendErLogin() -> String {
        return "\(ErLoginType2)sessions/current/extend"
    }
    
    func studentList(id:String) -> String {
        return "\(typeEvent2)community/events/\(id)/participants/student_user/list"
    }
    
    
    func checkInToken(id:String) -> String {
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        
        
        if isStudent ?? false
        {
            return "\(typeEvent1)students/events/\(id)/check-in/token"
            
        }
        else
        {
            return "\(typeEvent1)community/events/\(id)/check-in/token"
            
        }
        
    }
    
    func checkInTokenERSide() -> String {
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false
        {
            return ""
            
        }
        else
        {
            return "\(typeEvent1)community/event-check-in"
            
        }
        
    }
    
    func studentFunctionList() -> String {
        return "\(typeJob1)students/functional-area/list"
    }
    
    func studentIndustriesList() -> String {
        return "\(typeJob2)student/industries"
    }
    func globalCompanyList() -> String {
        return "\(typeJob2)student/global-companies/name"
        
    }
    
    func saveNotes()-> String{
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
              if isStudent ?? false
              {
                  return "\(Urls.runningEnvNotes)api/v1/student/notes"
              }
              else
              {
                  return "\(Urls.runningEnvNotes)api/v1/community/notes"

              }
    }
    
    func studentEditNotes(id:String)-> String{
        return "\(Urls.runningEnvNotes)api/v1/student/notes/" + "\(id)"
            
    }
    
    
    func deletesNotes(id: String)-> String{
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool

        if isStudent ?? false
        {
            return "\(Urls.runningEnvNotes)api/v1/student/notes/" + id

        }
        else
        {
            return "\(Urls.runningEnvNotes)api/v1/community/notes/" + id

        }
        
        
        
    }
    
    
    func cancelAppoinment(id: String)-> String{
        
        return "\(typeEvent1)students/appointment-slots/meetings/\(id)/cancel"
        
    }
    
    
    func feedBack(id: String)-> String{
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false
        {
            return "\(typeEvent2)students/appointments/\(id)/feedback"
        }
        else
        {
            return "\(typeEvent1)students/appointment-slots/\(id)/feedback"
        }
        
    }
    
    
    func finalize(id: String)-> String{
        
      
            return "\(typeEvent2)community/appointments/\(id)/finalize"
        
    }
    
    
    func erSideAppointment() -> String{
        return "\(typeEvent2)community/appointments/list"
        
    }
    
    func erSideOPenHourList() -> String{
           return "\(typeEvent2)community/open-hour/list"
           
       }
    
    func erSideAppointmentAccept(id: Int) -> String{
           return "\(typeEvent2)community/appointments/requests/" + "\(id)" + "/accept"
           
       }
    
    func erSideAppointmentNScomplete(id: String) -> String{
           return "\(typeEvent2)community/appointment-next-steps/" + "\(id)"
           
       }
    func erSideAppointmentDandC(id: String,idIndex: Int) -> String{
        if idIndex == 1{
            
            let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
            if isStudent ?? false
            {
                return "\(typeEvent2)students/appointments/" + "\(id)" + "/cancel"
            }
            else
            {
                return "\(typeEvent2)community/appointments/" + "\(id)" + "/cancel"
            }
        }
        else{
            return "\(typeEvent2)community/appointments/requests/" + "\(id)" + "/reject"
        }
    }
    
    func erSideAppointmentCancel(id: String) -> String{
              return "\(typeEvent1)community/appointment-slots/" + "\(id)" + "cancel"
              
          }
    
    func erSideOPenHourDetail(id: String) -> String{
        return "\(typeEvent2)community/open-hour/" + "\(id)"
        
    }
    
    
    func erSideOPenHourDelete(id: String,isDeleteAllcoocurence : String) -> String{
        return "\(typeEvent2)community/open-hour/" + "\(id)?delete_all_occurences=\(isDeleteAllcoocurence)"
        
    }
    
    func erSideOPenHourGetPurpose() -> String{
        return "\(typeEvent2)community/open-hour/purposes"
        
    }
    func erSideOPenHourGetProvider() -> String{
        return "\(typeEvent2)community/open-hour/locations/providers"
        
    }
    
    func erSideOPenHourTags() -> String{
        return "\(Urls.runningEnvJobs)students/api/v1/students/list/tags"
        
    }
    
    
    func erSideStudentList() -> String{
        return "\(type8)app-view"
        
    }
    func erSideRolelist() -> String{
           return "\(type9)users/roles"
           
       }
    
    func erSideSpecificUserlist() -> String{
              return "\(type9)users/list"
              
          }
    
    func createNewOpenHour() -> String{
           return "\(typeEvent2)community/open-hour"

       }
    func editedOpenHour(id: String) -> String{
        return "\(typeEvent2)community/open-hour/" + id

          }
    
    func erSideStudentListAppoinment() -> String{
        return "\(Urls.runningEnvJobs)students/api/v1/students"

    }
    
   
    
    func erSideUpdateAttendence(studentId: Int) -> String{
              return "\(typeEvent2)community/appointments/requests/\(studentId)/mark-attendance"
          }
    func erSideSubmitNotes()-> String{
        return "\(Urls.runningEnvNotes)api/v1/community/notes"
       }
    
    func erSideEditNotes(id: String)-> String{
        return "\(Urls.runningEnvNotes)api/v1/community/notes/\(id)"
       }
    
    func erSideStandardRepone()-> String{
           return "\(typeEvent2)community/appointment-next-steps/standard-responses"
          }
    
   func erSideSubmitNext()-> String{
    return "\(typeEvent2)community/appointment-next-steps"
   }
    
  
    func erSideDuplicatePurpose()-> String{
     return "\(typeEvent2)community/open-hour/duplicate/purposes"
    }
    
    func submitAdhocAppointment()-> String{
        return "\(typeEvent2)community/appointments/adhoc"
       }
    
    func erSideResumeView(resumeId:Int) -> String{
           return "\(type10)university/resumes/latest/pdf"
           
       }
    
    func studentSideRole(Id:String) -> String{
           return "\(type9)student/career_services/roles?_=\(Id)"
           
       }
    
    func studentSideExpertise(Id:String) -> String{
           return "\(type9)student/career_services/expertise?_=\(Id)"
           
       }
    func studentSideIndustries(Id:String) -> String{
           return "\(type9)student/career_services/expertise?_=\(Id)"
           
       }
    
    func studentSideClubs(Id:String) -> String{
           return "\(type9)student/career_services/clubs?_=\(Id)"
           
       }
}
