//
//  StringConstants.swift
//  Resume
//
//  Created by VM User on 08/03/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import UIKit

class StringConstants{
    
    static let competencies: String = "Competencies"
    static let presentation: String = "Presentation"
    static let impact: String = "Impact"
    static let howCompetencies: String = "How well presented are the various soft skills including Leadership, Teamwork, Problem Solving, etc?"
    static let howPresentation: String = "How well presented are various sections and bullets including format and overall layout?"
    static let howImapct: String = "How clearly defined are the sections and bullets in the resume and is the Impact clearly visible?"
    
    
    //Login String
    static let checkEmailStatusApiLoader = "Checking your email"
    static let loginApiLoader = "Authorizing"
    static let userInfoApiLoader = "Getting user details"
    static let communityInfoApiLoader = "Getting community details"
    static let signUpApiLoader = "Creating your account"
    static let forgotPasswprdApiLoader = "Sending email to recover your password"
    static let resendVerificationApiLoader = "Sending verification email"
    static let openingFacebookApiLoader = "Redirecting to facebook"
    static let openingLinkedInApiLoader = "Redirecting to linkedin"
    static let resetPasswordApiLoader = "Resetting your password"
    static let sessionExpiredApiLoader = "Session expired, logging out"
    static let logoutApiLoader = "Logging out"
    static let verifyingApiLoader = "Verifying"
    static let sectionFeedbackApiLoader = "Getting Section Feedback"
    
    static let emptyEmailError: String = "Please enter email"
    static let invalidEmailError: String = "Please enter valid email"
    static let emptyNameError: String = "Please enter name"
    static let invalidNameError: String = "Please enter valid name"
    static let emptyPasswordError: String = "Please enter password"
    static let invalidPasswordError: String = "Password should contain at least 8 characters, one uppercase character, one lowercase character, one number and one special character."
    static let emptyCaptchaError: String = "Please enter code"
    static let userVerifyError = "Something went wrong. Please try again"
    static let reminderInPastError = "Reminder cannot be scheduled in the past"
    
    static let forgotPasswordScreenText = "We will send a reset password link to"
    static let forgotPasswordSuccessText = "Password reset link has been mailed. Check your junk mail or spam folder."
    
    static let resendVerificationScreenText = "We have sent a verification link to"
    static let resendVerificationSuccessText = "A verification link is sent to your email. Remember to check your junk mail or spam folder."
    static let notAvailableForCommunityText = "Currently, this app is not available to your community. \n\n Hang on! We are working on it."
    static let resetLinkExpiredText = "This link is no longer valid. Please get a new link"
    static let resetPasswordSuccessText = "Your password has been reset successfully.\nYou will be logged out of all active sessions."
    static let alreadyLoginText = "You are already logged in"
    static let userVerifyFailedText = "This link might have already verified or expired. Please proceed to login or request a new link"
    static let userVerifySuccessText = "Your email has been verified successfully"
    static let userVerifySuccessApprovalPendingText = "Your email has been verified successfully. Your request has been sent to the community admin for approval."
    static let canRegisterFalse = "This email address is not allowed in this community. Please use your school email address."
    static let spellCheckTextYellow = "The words highlighted in Yellow have NO impact on your resume score. However, we recommend that you consider the spelling suggestions listed below!"
    static let spellCheckTextRed = "The words highlighted in Red are misspelled. Please correct the same!"
    
    static let appUpdateText = "There are important enhancements made to the application for smoother functioning. We strongly recommend you to update the app to the latest version from the App Store."
    static let appForceUpdateText = "We have ramped up our security to deliver a safer and smoother experience. To continue, please update your app from the AppStore."
    
    static let categoriesIncludedText = "Categories you have included"
    static let categoriesSuggestedText = "Categories you can include"
    static let resumeReparseText = "Reparsing resume"
    static let sectionNotIncludedText = "Your college template recommends you to add this section"
    static let exceedFileSizeText = "Please upload a file with size less than 2MB"
    static let nocoachSelected = "Please Select any coach"
    static let cantDeselectAll = "You have to select atleast one coach or alumni"
    static let FetchingCoachSelection = "Fetching Data... "

    
    static let AcceptOpenHour = "Accepting Request... "

    static let NEXTSTEPCOMPLETION = "Submitting Request... "

    static let SubmittingDandCOpenHour = "Submitting Request... "

    static let FINALIZINDAPPOINMENT = "Finalizsing Appointment... "

    
    static let DeletingOpenHour = "Deleting Open Hour... "

    
    static let SavingNotes = "Saving Notes... "
    
    static let CancelAppointment = "Cancel Appointment... "

    
    static let DeletingNotes = "Deleting Notes... "

    static let FeedbackNotes = "Submitting Feedback... "

    static let PURPOSEERROR = "Please select atleast one purpose"
    static let LOCATIONERROR = "Please provide your Location"

    static let DEADLINEERROR = "Please provide your Deadlines"

    static let STUDENTERROR = "Please select any Student"

    static let CONFIRMAPPOINTMENT = "Confirming Appointment..."
    static let KUPGRADETOLATESTOS = "This particular functionality needs latest OS, please upgarde your iOS version"
    static let coachInfoApiLoader = "Getting coach details"
    static let appointmentInfoApiLoader = "Getting Appointment details"
    static let ERTIMESLOTERROR = "Please specify the time for the slot. Ensure that the End time is greater than start time"

    static let ERSELECTAVAILABELTIMESLOTERROR = "Please select an available time slot"
    static let ERNOAVAILABELTIMESLOTERROR = "No available time slot"

    
    static let GROUPLIMITERROR = "Please provide group limit"
    static let GROUPLIMITRANGEERROR = "Please enter valid group size limit (between 1 to 15)"

    static let ERRADDNEXTSTEPDESCRIPTION = "Please enter description"
    static let ERRADDNEXTSTEPDATETIME = "Please enter date and time"
    static let ERRDUPLICATETIMEDATE = "Please enter both the date"
    static let ERRDUPLICATETIMESLOTSELECTED = "Please select atleast one time slot"

    static let ERRCOMMENTCANCELDECLINEAPPO = "Please enter comment"


    
}
