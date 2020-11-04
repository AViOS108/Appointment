// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct FeedBackModal: Codable {
    let id: String?
    let eventTypeID: Int?
    let title, welcomeDescription, timezone, startDatetimeUTC: String?
    let endDatetimeUTC: String?
    let duration, isAllDay: Int?
    let recurrence: JSONNull?
    let isRecurring: Int?
    let sessions: JSONNull?
    let state, createdAt: String?
    let deletedAt: JSONNull?
    let lastChangedAt, createdByID, createdByType: String?
    let parentID, parentType: JSONNull?
    let updatedByID, updatedByType: String?
    let type: TypeClass?
    let locations: [Location]?
    let participants: [Participant]?
    let calendars: [JSONAny]?
    let appointmentIsCompleted: Int?
    let locationsUniversityRoom, identifier: String?
    let isRecurringInstance, isSessionInstance, isSlotInstance: Bool?
    let idsHistory: [JSONAny]?
    let createdBy: CreatedBy?
    let startDatetime, endDatetime, inTimezone: String?
    let purposes: [JSONAny]?

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
        case type, locations, participants, calendars
        case appointmentIsCompleted = "appointment_is_completed"
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
    }
}



// MARK: - Location
struct Location: Codable {
    let id: Int?
    let eventID, provider: String?
    let meetingID: Int?
    let data: DataClass?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case provider
        case meetingID = "meeting_id"
        case data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let value: String?
}



