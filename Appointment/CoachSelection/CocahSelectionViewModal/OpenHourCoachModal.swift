//
//  OpenHourCoachModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 03/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct OpenHourCoachModal: Codable {
    var results: [OpenHourCoachModalResult]?
    var total: Int?
    var sectionHeader: [sectionHead]?

}



// MARK: - Result
struct OpenHourCoachModalResult: Codable {
    let id: String?
    var isPastAppointment : Bool = false
    var isFeedbackEnabled : Bool = false

    let eventTypeID: Int?
    let title, resultDescription, timezone, startDatetimeUTC: String?
    let endDatetimeUTC: String?
    let duration: Int?
    let state, createdAt, lastChangedAt, createdByID: String?
    let createdByType, updatedByID, updatedByType: String?
    let type: TypeClass?
    let participants: [Participant]?
    let calendars:[String]?
    let parent: [Parent]?
    let locationsUniversityRoom, openHoursAppointmentApprovalProcess, slotDuration, identifier: String?
    let isRecurringInstance, isSessionInstance, isSlotInstance: Bool?
    let idsHistory: [String]?
    let startDatetime, endDatetime, inTimezone: String?
    let createdBy: CreatedBy!
    let purposes: [Purpose]?
    var coach : Coach?
    let appointmentIsCompleted: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case eventTypeID = "event_type_id"
        case title
        case resultDescription = "description"
        case timezone
        case startDatetimeUTC = "start_datetime_utc"
        case endDatetimeUTC = "end_datetime_utc"
        case duration, state
        case createdAt = "created_at"
        case lastChangedAt = "last_changed_at"
        case createdByID = "created_by_id"
        case createdByType = "created_by_type"
        case updatedByID = "updated_by_id"
        case updatedByType = "updated_by_type"
        case type, participants, calendars, parent
        case locationsUniversityRoom = "locations_university_room"
        case openHoursAppointmentApprovalProcess = "open_hours_appointment_approval_process"
        case slotDuration = "slot_duration"
        case identifier
        case isRecurringInstance = "is_recurring_instance"
        case isSessionInstance = "is_session_instance"
        case isSlotInstance = "is_slot_instance"
        case idsHistory = "ids_history"
        case startDatetime = "start_datetime"
        case endDatetime = "end_datetime"
        case inTimezone = "in_timezone"
        case createdBy = "created_by"
        case appointmentIsCompleted = "appointment_is_completed"

        case purposes
    }
    
}



struct Parent: Codable {
    let timezone, state, createdAt, originalStartDatetimeUTC: String?
    let createdByType: String?
    let type: TypeClass?
    let parentID: String?
    let openHoursAppointmentApprovalProcess, createdByID, slotDuration: String?
    let eventTypeID: Int?
    let startDatetimeUTC: String?
    let idsHistory: [JSONAny]?
    let sessions: String?
    let identifier, originalEndDatetimeUTC, lastChangedAt: String?
    let parentType: String?
    let updatedByType, id: String?
    let deletedAt: String?
    let isAllDay: Int?
    let isSlotInstance: Bool?
    let parentDescription: String?
    let isRecurringInstance: Bool?
    let recurrence: String?
    let duration: Int?
    let locationsUniversityRoom: String?
    let isRecurring: Int?
    let title, updatedByID, endDatetimeUTC: String?
    let parent: [JSONAny]?
    let pivot: Pivot?
    let isSessionInstance: Bool?

    enum CodingKeys: String, CodingKey {
        case timezone, state
        case createdAt = "created_at"
        case originalStartDatetimeUTC = "original_start_datetime_utc"
        case createdByType = "created_by_type"
        case type
        case parentID = "parent_id"
        case openHoursAppointmentApprovalProcess = "open_hours_appointment_approval_process"
        case createdByID = "created_by_id"
        case slotDuration = "slot_duration"
        case eventTypeID = "event_type_id"
        case startDatetimeUTC = "start_datetime_utc"
        case idsHistory = "ids_history"
        case sessions, identifier
        case originalEndDatetimeUTC = "original_end_datetime_utc"
        case lastChangedAt = "last_changed_at"
        case parentType = "parent_type"
        case updatedByType = "updated_by_type"
        case id
        case deletedAt = "deleted_at"
        case isAllDay = "is_all_day"
        case isSlotInstance = "is_slot_instance"
        case parentDescription = "description"
        case isRecurringInstance = "is_recurring_instance"
        case recurrence, duration
        case locationsUniversityRoom = "locations_university_room"
        case isRecurring = "is_recurring"
        case title
        case updatedByID = "updated_by_id"
        case endDatetimeUTC = "end_datetime_utc"
        case parent, pivot
        case isSessionInstance = "is_session_instance"
    }
}


struct Pivot: Codable {
    let parentEventID, exceptionEventID: String?

    enum CodingKeys: String, CodingKey {
        case parentEventID = "parent_event_id"
        case exceptionEventID = "exception_event_id"
    }
}


// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int?
    let name, email: String?
    let communityID: Int?
    let communityName: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case communityID = "community_id"
        case communityName = "community_name"
    }
}


struct Feedback: Codable {
    let averageRating: Float?
    let createdAt: String?
    let coachHelpfulness: Int?
    let updatedAt: String?
    let coachExpertise, overallExperience, id: Int?
    let comments: String?

    enum CodingKeys: String, CodingKey {
        case averageRating = "average_rating"
        case createdAt = "created_at"
        case coachHelpfulness = "coach_helpfulness"
        case updatedAt = "updated_at"
        case coachExpertise = "coach_expertise"
        case overallExperience = "overall_experience"
        case id, comments
    }
}

// MARK: - Participant
struct Participant: Codable {
    let id: Int?
    let entityID: String?
    let entityType: String?
    let isEventVisible: Int?
    let hasBookmark: String?
    let isInvited: Int?
    let role: String?
    let feedback: Feedback?
    let sessions: [String]?
    let firstName: String?
    let lastName: String?
    let name, email: String?
    let benchmarkID: Int?
    let benchmarkName: String?
    let communityID: Int?
    let communityName: String?
    let miUserID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case entityID = "entity_id"
        case entityType = "entity_type"
        case isEventVisible = "is_event_visible"
        case hasBookmark = "has_bookmark"
        case isInvited = "is_invited"
        case role, feedback, sessions
        case firstName = "first_name"
        case lastName = "last_name"
        case name, email
        case benchmarkID = "benchmark_id"
        case benchmarkName = "benchmark_name"
        case communityID = "community_id"
        case communityName = "community_name"
        case miUserID = "mi_user_id"
    }
}



// MARK: - Purpose
struct Purpose: Codable {
    let id: Int?
    let eventID: String?
    let userPurposeID: Int?
    let createdByID, createdByType: String?
    let userPurpose: UserPurpose?
    let createdBy: CreatedBy?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case userPurposeID = "user_purpose_id"
        case createdByID = "created_by_id"
        case createdByType = "created_by_type"
        case userPurpose = "user_purpose"
        case createdBy = "created_by"
    }
}

// MARK: - UserPurpose
struct UserPurpose: Codable {
    let id: Int?
    let displayName, machineName: String?
    let createdByID, createdByType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case machineName = "machine_name"
        case createdByID = "created_by_id"
        case createdByType = "created_by_type"
    }
}

// MARK: - TypeClass
struct TypeClass: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Encode/decode helpers

