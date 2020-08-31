//
//  StoryboardExtensions.swift
//  Resume
//
//  Created by VM User on 14/02/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    //MARK: - Storyboard declaration
    class func dashboardStroyboard() -> UIStoryboard {
        return UIStoryboard(name: "Dashboard", bundle: Bundle.main)
    }
    
    class func loginStroyboard() -> UIStoryboard {
        return UIStoryboard(name: "Login", bundle: Bundle.main)
    }
    
    class func homeStroyboard() -> UIStoryboard {
        return UIStoryboard(name: "Home", bundle: Bundle.main)
    }
    
    class func settingsStroyboard() -> UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: Bundle.main)
    }
    
    class func mobileResumeFormatStroyboard() -> UIStoryboard {
        return UIStoryboard(name: "MobileResumeFormat", bundle: Bundle.main)
    }
    
    class func networkFeedbackStroyboard() -> UIStoryboard {
        return UIStoryboard(name: "NetworkFeedback", bundle: Bundle.main)
    }
    
    // controller instantiate
    
    //MARK: - INTRO
    
    class func introScreen() -> IntroPageViewController {
        return (loginStroyboard().instantiateViewController(withIdentifier: "IntroPageViewController") as? IntroPageViewController)!
    }
    
    class func introVC() -> IntroViewController {
        return (loginStroyboard().instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController)!
    }

    //MARK: - LOGIN
    
    class func prefilledCommunity() -> PrefilledCommunityViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "PrefilledCommunityViewController") as? PrefilledCommunityViewController)!
    }
    
    class func communityList() -> CommunityListViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "CommunityListViewController") as? CommunityListViewController)!
    }
    
    class func checkStatus() -> CheckStatusViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "CheckStatusViewController") as? CheckStatusViewController)!
    }
    
    class func ssoLogin() -> SSOLoginViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "SSOLoginViewController") as? SSOLoginViewController)!
    }
    
    class func socialLoginView() -> SocialLoginViewController {
        return (loginStroyboard().instantiateViewController(withIdentifier: "SocialLoginViewController") as? SocialLoginViewController)!
    }
    
    class func loginWithEmail() -> LoginWithEmailViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "LoginWithEmailViewController") as? LoginWithEmailViewController)!
    }
    
    class func register() -> RegisterViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController)!
    }
    
    class func modifiedRegister() -> ModifiedRegisterViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "ModifiedRegisterViewController") as? ModifiedRegisterViewController)!
    }
    
    class func forgot() -> ForgotPasswordViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController)!
    }
    
    class func waitingApproval() -> WaitingForApprovalViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "WaitingForApprovalViewController") as? WaitingForApprovalViewController)!
    }
    
    class func registerSuccess() -> VerificationPendingViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "VerificationPendingViewController") as? VerificationPendingViewController)!
    }
    
    class func verifyUser() -> VerificatonCompletedViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "VerificatonCompletedViewController") as? VerificatonCompletedViewController)!
    }

    
    class func selectCommunity() -> SelectCommunityViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "SelectCommunityViewController") as? SelectCommunityViewController)!
    }
    
    class func resumeNotEnabled() -> ResumeNotEnabledViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "ResumeNotEnabledViewController") as? ResumeNotEnabledViewController)!
    }
    
    class func resetPassword() -> ResetPasswordViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController)!
    }
    class func agreementConsent() -> AgreementConsentViewController{
        return (loginStroyboard().instantiateViewController(withIdentifier: "AgreementConsentViewController") as? AgreementConsentViewController)!
    }
    
    //MARK: - DASHBOARD
//    class func dashboardTabBar() -> DashboardTabBarViewController{
//        return (dashboardStroyboard().instantiateViewController(withIdentifier: "DashboardTabBarViewController") as? DashboardTabBarViewController)!
//    }
//    
//    class func accountsNavigationBar() -> AccountDetailsNavigationController{
//        return (dashboardStroyboard().instantiateViewController(withIdentifier: "AccountDetailsNavigationController") as? AccountDetailsNavigationController)!
//    }
//    
//    class func carrerNavigationBar() -> CarrerPreferenceNavigationViewController{
//        return (dashboardStroyboard().instantiateViewController(withIdentifier: "CarrerPreferenceNavigationViewController") as? CarrerPreferenceNavigationViewController)!
//    }
//    
//    
//    class func filterNotes() -> FilterNotesViewController{
//        return (dashboardStroyboard().instantiateViewController(withIdentifier: "FilterNotesViewController") as? FilterNotesViewController)!
//    }
//    
//    class func search() -> SearchViewController{
//        return (dashboardStroyboard().instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController)!
//    }
//    
//    class func createNote() -> CreateNoteViewController{
//        return (dashboardStroyboard().instantiateViewController(withIdentifier: "CreateNoteViewController") as? CreateNoteViewController)!
//    }
//    
//    //MARK: - Home
//    class func homeView() -> HomeViewController{
//        return (homeStroyboard().instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
//    }
//    
//    class func documentViewer() -> DocumentListViewController{
//        return (homeStroyboard().instantiateViewController(withIdentifier: "DocumentListViewController") as? DocumentListViewController)!
//    }
//    
//    class func googleDriveViewer() -> GoogleDriveViewController{
//        return (homeStroyboard().instantiateViewController(withIdentifier: "GoogleDriveViewController") as? GoogleDriveViewController)!
//    }
//    
//    //MARK: - Settings
    class func webViewer() -> WebViewController{
        return (settingsStroyboard().instantiateViewController(withIdentifier: "WebViewController") as? WebViewController)!
    }
//    
//    class func profileView() -> ProfileViewController{
//        return (settingsStroyboard().instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController)!
//    }
//    
//    class func paymentWebView() -> PaymentGatewayWebViewController{
//        return (settingsStroyboard().instantiateViewController(withIdentifier: "PaymentGatewayWebViewController") as? PaymentGatewayWebViewController)!
//    }
//    
//    class func paypalWebViewController() -> PaypalWebViewController{
//        return (settingsStroyboard().instantiateViewController(withIdentifier: "PaypalWebViewController") as? PaypalWebViewController)!
//    }
//    
//    
//    class func recieptView() -> RecieptsViewController{
//        return (settingsStroyboard().instantiateViewController(withIdentifier: "RecieptsViewController") as? RecieptsViewController)!
//    }
//    
//    class func premiumAccountController() -> PremiumAccountDetailsViewController{
//        return (settingsStroyboard().instantiateViewController(withIdentifier: "PremiumAccountDetailsViewController") as? PremiumAccountDetailsViewController)!
//    }
//    
//    class func paymentNavigationBarViewController() -> PaymentNavigationBarViewController{
//        return (settingsStroyboard().instantiateViewController(withIdentifier: "PaymentNavigationBarViewController") as? PaymentNavigationBarViewController)!
//    }
//    
//    class func inviteNavigationViewController() -> UINavigationController{
//        return (settingsStroyboard().instantiateViewController(withIdentifier: "InviteNavigationViewController") as? UINavigationController)!
//    }
//    
//    class func contactsViewController() -> ContactsViewController{
//        return (settingsStroyboard().instantiateViewController(withIdentifier: "ContactsViewController") as? ContactsViewController)!
//    }
//    
//    
//    //MARK: - Mobile Resume
////    class func mobileResumeViewController() -> MobileFormatResumeViewController{
////        return (mobileResumeFormatStroyboard().instantiateViewController(withIdentifier: "MobileFormatResumeViewController") as? MobileFormatResumeViewController)!
////    }
//    
//    class func systemFeedbackViewController() -> SystemFeedbackViewController{
//        return (mobileResumeFormatStroyboard().instantiateViewController(withIdentifier: "SystemFeedbackViewController") as? SystemFeedbackViewController)!
//    }
//    
//    class func bulletFeedbackViewController() -> BulletFeedbackViewController{
//        return (mobileResumeFormatStroyboard().instantiateViewController(withIdentifier: "BulletFeedbackViewController") as? BulletFeedbackViewController)!
//    }    
//    
//    class func bulletDetailViewController() -> BulletDetailViewController{
//        return (mobileResumeFormatStroyboard().instantiateViewController(withIdentifier: "BulletDetailViewController") as? BulletDetailViewController)!
//    }
//    
//    class func scoreViewController() -> ScoreViewController{
//        return (mobileResumeFormatStroyboard().instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController)!
//    }
//    
//    
//    //MARK: - Ask Feedback
//    class func askFeedbackController() -> AskFeedbackTabBatViewController{
//        return (networkFeedbackStroyboard().instantiateViewController(withIdentifier: "AskFeedbackTabBatViewController") as? AskFeedbackTabBatViewController)!
//    }
//    
//    
//    class func socialViewController() -> SocialViewController{
//        return (networkFeedbackStroyboard().instantiateViewController(withIdentifier: "SocialViewController") as? SocialViewController)!
//    }
//    
//    class func emailViewController() -> EmailViewController{
//        return (networkFeedbackStroyboard().instantiateViewController(withIdentifier: "EmailViewController") as? EmailViewController)!
//    }
//    
//    class func recentViewController() -> RecentViewController{
//        return (networkFeedbackStroyboard().instantiateViewController(withIdentifier: "RecentViewController") as? RecentViewController)!
//    }
//    
//    class func coachesViewController() -> CoachesViewController{
//        return (networkFeedbackStroyboard().instantiateViewController(withIdentifier: "CoachesViewController") as? CoachesViewController)!
//    }
//    
//    
//    //MARK: - View Feedback
//    class func sendFeedbackSummaryViewController() -> SendFeedbackSummaryViewController{
//        return (networkFeedbackStroyboard().instantiateViewController(withIdentifier: "SendFeedbackSummaryViewController") as? SendFeedbackSummaryViewController)!
//    }
//    
//    class func viewFeedbackTabbarController() -> ViewFeedbackTabbarViewController{
//        return (networkFeedbackStroyboard().instantiateViewController(withIdentifier: "ViewFeedbackTabbarViewController") as? ViewFeedbackTabbarViewController)!
//    }
//    
//    class func feedbackResultViewController() -> FeedbackResultViewController{
//        return (networkFeedbackStroyboard().instantiateViewController(withIdentifier: "FeedbackResultViewController") as? FeedbackResultViewController)!
//    }
//    
//    class func feedbackPendingViewController() -> FeedbackPendingViewController{
//        return (networkFeedbackStroyboard().instantiateViewController(withIdentifier: "FeedbackPendingViewController") as? FeedbackPendingViewController)!
//    }
//    
//    class func sectionFeedbackContainerVC() -> SectionFeedbackContainerViewController{
//        return (mobileResumeFormatStroyboard().instantiateViewController(withIdentifier: "SectionFeedbackContainerViewController") as? SectionFeedbackContainerViewController)!
//    }
//    
//    class func sectionIncludedVC() -> SectionIncludedViewController{
//        return (mobileResumeFormatStroyboard().instantiateViewController(withIdentifier: "SectionIncludedViewController") as? SectionIncludedViewController)!
//    }
//    
//    class func sectionNotIncludedVC() -> SectionNotIncludedViewController{
//        return (mobileResumeFormatStroyboard().instantiateViewController(withIdentifier: "SectionNotIncludedViewController") as? SectionNotIncludedViewController)!
//    }
}
