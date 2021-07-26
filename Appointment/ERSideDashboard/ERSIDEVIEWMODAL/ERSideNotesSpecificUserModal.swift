//
//  ERSideNotesModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import Foundation


struct ERSideRoleSpecificUserModal: Codable {
    let total: Int?
    var items: [Role]?
}

// MARK: - Welcome
struct ERSideNotesSpecificUserModal: Codable {
    var items: [ERSideNotesSpecificUserModalItem]?
    var total: Int?
}

// MARK: - Item
struct ERSideNotesSpecificUserModalItem: Codable {
    var isSelected = false
    var id: Int?
    var name, email: String?
    var communityID: Int?
    var profilePicURL: String?
    var isDeleted, allowRequestsEmailNotifications: Int?
    var createdDate, lastUpdatedDate: String?
    var networkFeedbackVisibility: Bool?
    var createdByUser, updatedByUser: AtedByUser?
    var roles: [Role]?
    var assignedBenchmarks: [AssignedBenchmark]?
    var tags: [Tags]?
    var coachInfo: CoachInfo?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case communityID = "community_id"
        case profilePicURL = "profile_pic_url"
        case isDeleted = "is_deleted"
        case allowRequestsEmailNotifications = "allow_requests_email_notifications"
        case createdDate = "created_date"
        case lastUpdatedDate = "last_updated_date"
        case networkFeedbackVisibility = "network_feedback_visibility"
        case createdByUser = "created_by_user"
        case updatedByUser = "updated_by_user"
        case roles
        case assignedBenchmarks = "assigned_benchmarks"
        case tags
        case coachInfo = "coach_info"
    }
}

// MARK: - AssignedBenchmark
struct AssignedBenchmark: Codable {
    let id: Int?
    let identifier, displayName: String?

    enum CodingKeys: String, CodingKey {
        case id, identifier
        case displayName = "display_name"
    }
}

// MARK: - CoachInfo
struct CoachInfo: Codable {
    let headline, summary: String?
    let showToStudents, appointmentVisibilityShowToStudents: Int?

    enum CodingKeys: String, CodingKey {
        case headline, summary
        case showToStudents = "show_to_students"
        case appointmentVisibilityShowToStudents = "appointment_visibility_show_to_students"
    }
}

// MARK: - AtedByUser
struct AtedByUser: Codable {
    let id: Int?
    let name, email: String?
}

// MARK: - Role
struct Role: Codable {
    var isSelected = false
    var id: Int?
    var machineName, displayName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case machineName = "machine_name"
        case displayName = "display_name"
    }
}
