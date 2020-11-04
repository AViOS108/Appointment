//
//  AppoinmentDetailModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 22/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct AppoinmentDetailModal: Codable {
    let id: String?
    let eventTypeID: Int?
    let title, welcomeDescription, timezone, startDatetimeUTC: String?
    let endDatetimeUTC: String?
    let duration, isAllDay: Int?
    let recurrence: String?
    let isRecurring: Int?
    let sessions: String?
    let state, createdAt: String?
    let deletedAt: String?
    let lastChangedAt, createdByID, createdByType: String?
    let parentID, parentType: String?
    let updatedByID, updatedByType: String?
    let type: TypeClass?
    let participants: [Participant]?
    let calendars: [JSONAny]?
    let attachmentsPublic: [AttachmentsPublic]?
    let locationsUniversityRoom, identifier: String?
    let isRecurringInstance, isSessionInstance, isSlotInstance: Bool?
    let idsHistory: [JSONAny]?
    let createdBy: WelcomeCreatedBy?
    let startDatetime, endDatetime, inTimezone: String?
    let purposes: [Purpose]?
    var coach : Coach?
    var parent: [Parent]?
    let locations: [Location]?

    enum CodingKeys: String, CodingKey {
        case id
        case eventTypeID = "event_type_id"
        case title
        case welcomeDescription = "description"
        case timezone
        case startDatetimeUTC = "start_datetime_utc"
        case endDatetimeUTC = "end_datetime_utc"
        case duration
        case isAllDay = "is_all_day"
        case recurrence
        case isRecurring = "is_recurring"
        case sessions, state
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case lastChangedAt = "last_changed_at"
        case createdByID = "created_by_id"
        case createdByType = "created_by_type"
        case parentID = "parent_id"
        case parentType = "parent_type"
        case updatedByID = "updated_by_id"
        case updatedByType = "updated_by_type"
        case type, participants, calendars
        case attachmentsPublic = "attachments_public"
        case locationsUniversityRoom = "locations_university_room"
        case identifier
        case isRecurringInstance = "is_recurring_instance"
        case isSessionInstance = "is_session_instance"
        case isSlotInstance = "is_slot_instance"
        case idsHistory = "ids_history"
        case createdBy = "created_by"
        case startDatetime = "start_datetime"
        case endDatetime = "end_datetime"
        case inTimezone = "in_timezone"
        case purposes
        case locations
    }
}

// MARK: - AttachmentsPublic
struct AttachmentsPublic: Codable {
    let name: String?
    let attachmentsPublicExtension: Extension?
    let url: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case attachmentsPublicExtension = "extension"
        case url, id
    }
}

// MARK: - Extension
struct Extension: Codable {
    let client, guess: String?
}

// MARK: - WelcomeCreatedBy
struct WelcomeCreatedBy: Codable {
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





// MARK: - PurposeCreatedBy
struct PurposeCreatedBy: Codable {
    let id: Int?
    let firstName, lastName, name, email: String?
    let benchmarkID: Int?
    let benchmarkName: String?
    let communityID: Int?
    let communityName: String?
    let miUserID: Int?

    enum CodingKeys: String, CodingKey {
        case id
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




struct NotesModal: Codable {
    var results: [NotesResult]?
    var isExpandableNotes : Bool?
}

// MARK: - Result
struct NotesResult: Codable {
    let id: Int?
    var data, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, data
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}



struct NotesSubmitModal: Codable {
    let id: Int?
    let data, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, data
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct NextStepModal: Codable {
    let id: Int?
    let appointmentID, data, dueDatetime, isCompleted: String?
    let isSharedWithParticipants, createdByID, createdByType, createdAt: String?
    let updatedByID, updatedByType: String?
    let updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case appointmentID = "appointment_id"
        case data
        case dueDatetime = "due_datetime"
        case isCompleted = "is_completed"
        case isSharedWithParticipants = "is_shared_with_participants"
        case createdByID = "created_by_id"
        case createdByType = "created_by_type"
        case createdAt = "created_at"
        case updatedByID = "updated_by_id"
        case updatedByType = "updated_by_type"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

typealias NextStepArr = [NextStepModal]



struct ApooinmentDetailAllModal {
    var nextModalObj : [NextStepModal]?
    var noteModalObj :   NotesModal?
    var coachNoteModalObj :   NotesModal?
    var appoinmentDetailModalObj : AppoinmentDetailModal?
}






