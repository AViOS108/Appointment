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
    let calendars: [String]?
    let attachmentsPublic: [AttachmentsPublic]?
    let locationsUniversityRoom, identifier: String?
    let isRecurringInstance, isSessionInstance, isSlotInstance: Bool?
    let idsHistory: [String]?
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


/////////////// NEW Appoinment Detail Modal


struct AppoinmentDetailModalNew: Codable {
    let id: Int?
    let startDatetimeUTC, endDatetimeUTC, timezone, location: String?
    let locationType, state: String?
    let coachID: Int?
    let cancellationReason: String?
    var requests: [RequestER]?
    let nextsteps: [Nextstep]?
    let appointmentConfig: AppointmentConfig?
    let title, type: String?
    let coachDetails: CoachDetails?
    let startDatetime, endDatetime, inTimezone: String?
    var coachDetailApi: CoachDetailApi?

    enum CodingKeys: String, CodingKey {
        case id
        case startDatetimeUTC = "start_datetime_utc"
        case endDatetimeUTC = "end_datetime_utc"
        case timezone, location
        case locationType = "location_type"
        case state
        case coachID = "coach_id"
        case cancellationReason = "cancellation_reason"
        case requests, nextsteps
        case appointmentConfig = "appointment_config"
        case title, type
        case coachDetails = "coach_details"
        case startDatetime = "start_datetime"
        case endDatetime = "end_datetime"
        case inTimezone = "in_timezone"
    }
}

// MARK: - Coach Detail

// MARK: - WelcomeElement

struct CoachDetailApi: Codable {
    let id: Int
    let name, email: String
    let communityID: Int
    let profilePicURL: String?
    let isDeleted, allowRequestsEmailNotifications: Int
    let createdDate, lastUpdatedDate: String
    let roles: [Role]
    let assignedBenchmarks: [AssignedBenchmark]
    let coachInfo: CoachInfo
  
//    let publications, educations, experiences, clubs: [String]
//    let permissions: [String: Bool]

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case communityID = "community_id"
        case profilePicURL = "profile_pic_url"
        case isDeleted = "is_deleted"
        case allowRequestsEmailNotifications = "allow_requests_email_notifications"
        case createdDate = "created_date"
        case lastUpdatedDate = "last_updated_date"
        case roles
        case assignedBenchmarks = "assigned_benchmarks"
        case coachInfo = "coach_info"
//        case publications, educations, experiences, clubs, permissions
    }
}




// MARK: - Nextstep
struct Nextstep: Codable {
    let id, appointmentID: Int?
    let data, dueDatetime: String?
    let isCompleted, coachID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case appointmentID = "appointment_id"
        case data
        case dueDatetime = "due_datetime"
        case isCompleted = "is_completed"
        case coachID = "coach_id"
    }
}
/////////////// NEW NWXT STEP

// MARK: - WelcomeElement
struct NextStepModalNew: Codable {
    let id, appointmentID: Int?
    let data, dueDatetime: String?
    let isCompleted, coachID: Int?
    let createdAt: String?
    let students: [Student]?
    let createdBy: CreatedBy?

    enum CodingKeys: String, CodingKey {
        case id
        case appointmentID = "appointment_id"
        case data
        case dueDatetime = "due_datetime"
        case isCompleted = "is_completed"
        case coachID = "coach_id"
        case students
        case createdAt = "created_at"
        case createdBy = "created_by"
    }
}


// MARK: - Student
struct Student: Codable {
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

typealias NextStepModalNewArr = [NextStepModalNew]


//////////////// NEW NOTES Modal


import Foundation

// MARK: - Welcome
struct NotesModalNew: Codable {
    let total: Int?
    let results: [NotesModalNewResult]?

}

// MARK: - Result
struct NotesModalNewResult: Codable {
    let id: Int?
    let data: String?
    let createdBy: CreatedBy?
    let canUpdate: Bool?
    let createdAt, updatedAt: String?
    let entities: [Entity]?

    
    enum CodingKeys: String, CodingKey {
           case id, data
           case createdBy = "created_by"
           case canUpdate = "can_update"
           case createdAt = "created_at"
           case updatedAt = "updated_at"
           case entities
       }
   
}

// MARK: - Entity
struct Entity: Codable {
    let info: NotesModalNewInfo?
    let id: Int?
    let entityID, entityType, canViewNote: String?

    enum CodingKeys: String, CodingKey {
        case info, id
        case entityID = "entity_id"
        case entityType = "entity_type"
        case canViewNote = "can_view_note"
    }
}

// MARK: - Info
struct NotesModalNewInfo: Codable {
let id: Int?
let machineName, displayName, firstName, lastName: String?
let name, email: String?
let benchmarkID: Int?
let benchmarkName: String?
let communityID: Int?
let communityName: String?
let miUserID: Int?
let startDatetimeUTC, endDatetimeUTC, timezone, location: String?
let locationType, state: String?
let coachID: Int?
let cancellationReason: String?
let requests: [Request]?
let appointmentConfig: AppointmentConfig?
let title, type, startDatetime, endDatetime: String?
let inTimezone: String?
let coachDetails: CoachDetails?
let profilePicURL: String?
let isDeleted: Int?

enum CodingKeys: String, CodingKey {
    case id
    case machineName = "machine_name"
    case displayName = "display_name"
    case firstName = "first_name"
    case lastName = "last_name"
    case name, email
    case benchmarkID = "benchmark_id"
    case benchmarkName = "benchmark_name"
    case communityID = "community_id"
    case communityName = "community_name"
    case miUserID = "mi_user_id"
    case startDatetimeUTC = "start_datetime_utc"
    case endDatetimeUTC = "end_datetime_utc"
    case timezone, location
    case locationType = "location_type"
    case state
    case coachID = "coach_id"
    case cancellationReason = "cancellation_reason"
    case requests
    case appointmentConfig = "appointment_config"
    case title, type
    case startDatetime = "start_datetime"
    case endDatetime = "end_datetime"
    case inTimezone = "in_timezone"
    case coachDetails = "coach_details"
    case profilePicURL = "profile_pic_url"
    case isDeleted = "is_deleted"
}

}




struct ApooinmentDetailAllNewModal {
    var nextModalObj : [NextStepModalNew]?
    var noteModalObj :   NotesModalNew?
    var coachNoteModalObj :   NotesModalNew?
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?
    var noteModalObjStudent :  NotesModal?

    var status : Int = 0
}


struct ApooinmentDetailAllModal {
    var nextModalObj : [NextStepModal]?
    var noteModalObj :   NotesModal?
    var coachNoteModalObj :   NotesModal?
    var appoinmentDetailModalObj : AppoinmentDetailModal?
}






