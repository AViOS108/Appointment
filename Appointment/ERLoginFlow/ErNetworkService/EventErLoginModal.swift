//
//  EventErLoginModal.swift
//  Event
//
//  Created by Anurag Bhakuni on 29/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct EventErLoginModal: Codable {
    let areDetailsRequired, isEnabled: Bool?
    let communityID: Int?
    let exists: Bool?
    let id: Int?
    let bccEmail: String?
    let isNewAdminEnabled: Bool?
    let logo: String?
    let isImsEnabled, isPasswordExpired: Bool?
    let sessionLifetime: Int?
    let isSsoEnabled, forcePasswordChange: Bool?
    let loginID: Int?
    let isResumeCalledCv, canRegister: Bool?
    let communityTagName: String?
    let areRequestEmailNotificationsAllowed: Bool?
    let permissions: Permission?
    let picture: String?
    let email, communityName, name: String?
    let activity: Activity?
    let benchmarks: [Benchmark]?
    let replyToEmail, oldestActivityDateTime: String?
    let isSCMEnabled: Bool?
    let csrfToken: String?

    enum CodingKeys: String, CodingKey {
        case areDetailsRequired, isEnabled
        case communityID = "communityId"
        case exists, id, bccEmail, isNewAdminEnabled, logo, isImsEnabled, isPasswordExpired
        case sessionLifetime = "session_lifetime"
        case isSsoEnabled, forcePasswordChange
        case loginID = "loginId"
        case isResumeCalledCv, canRegister, communityTagName, areRequestEmailNotificationsAllowed, permissions, picture, email, communityName, name, activity, benchmarks, replyToEmail, oldestActivityDateTime
        case isSCMEnabled = "isScmEnabled"
        case csrfToken = "csrf_token"
    }
}


struct Permission : Codable {
    let event_management_access : Bool?
    let event_management_events_access : Bool?
    let event_management_campaigns_access : Bool?

    enum CodingKeys: String, CodingKey {
           case event_management_access = "event_management.access"
           case event_management_events_access = "event_management.events.access"
           case event_management_campaigns_access = "event_management.campaigns.access"
       }
}

// MARK: - Activity
struct Activity: Codable {
    let userManagementTour, tagManagementTour, login, invitationsTour: Bool?
    let studentListingTour, nfTour: Bool?

    enum CodingKeys: String, CodingKey {
        case userManagementTour = "user_management_tour"
        case tagManagementTour = "tag_management_tour"
        case login
        case invitationsTour = "invitations_tour"
        case studentListingTour = "student_listing_tour"
        case nfTour = "nf_tour"
    }
}

// MARK: - Benchmark
struct Benchmark: Codable {
    let name: String?
    let id: Int?
}

// MARK: - Encode/decode helpers

class ERLoginJSONNull: Codable, Hashable {
    static func == (lhs: ERLoginJSONNull, rhs: ERLoginJSONNull) -> Bool {
                return true

    }
  
    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(ERLoginJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
