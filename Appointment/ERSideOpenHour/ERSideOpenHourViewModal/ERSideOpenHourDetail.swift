//
//  ERSideOpenHourDetail.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 30/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)


import Foundation

// MARK: - Welcome
struct ERSideOpenHourDetail: Codable {
    let appointmentCountsByDate: [AppointmentCountsByDate]?
    let createdByID, lastChangedAt: String?
    let parentID: JSONNull?
    let endDatetime, slotDuration, welcomeDescription: String?
    //
    let exceptions: [Exception]?
    let parentType: JSONNull?
    let inTimezone, identifier, title: String?
    let isRecurringInstance: Bool?
    let sessions: JSONNull?
    let duration: Int?
    let deletedAt: JSONNull?
    let startDatetime: String?
    let type: TypeClass?
    let isSessionInstance: Bool?
    let id: String?
    let idsHistory: [String]?
    let updatedByID: String?
    let createdBy: CreatedBy?
    let endDatetimeUTC: String?
    let updatedByType: String?
    let participants: [Participant]?
    let eventTypeID: Int?
    let recurrence: JSONNull?
    let isAllDay, isRecurring: Int?
    let createdByType: String?
    let calendars: [JSONAny]?
    let purposes: [Purpose]?
    let timezone, createdAt, state: String?
    let isSlotInstance: Bool?
    let parent: [JSONAny]?
    let locations: [Location]?
    let startDatetimeUTC: String?
    let period: JSONNull?
    let openHoursAppointmentApprovalProcess: String?

    enum CodingKeys: String, CodingKey {
        case appointmentCountsByDate = "appointment_counts_by_date"
        case createdByID = "created_by_id"
        case lastChangedAt = "last_changed_at"
        case parentID = "parent_id"
        case endDatetime = "end_datetime"
        case slotDuration = "slot_duration"
        case welcomeDescription = "description"
        case exceptions
        case parentType = "parent_type"
        case inTimezone = "in_timezone"
        case identifier, title
        case isRecurringInstance = "is_recurring_instance"
        case sessions, duration
        case deletedAt = "deleted_at"
        case startDatetime = "start_datetime"
        case type
        case isSessionInstance = "is_session_instance"
        case id
        case idsHistory = "ids_history"
        case updatedByID = "updated_by_id"
        case createdBy = "created_by"
        case endDatetimeUTC = "end_datetime_utc"
        case updatedByType = "updated_by_type"
        case participants
        case eventTypeID = "event_type_id"
        case recurrence
        case isAllDay = "is_all_day"
        case isRecurring = "is_recurring"
        case createdByType = "created_by_type"
        case calendars, purposes, timezone
        case createdAt = "created_at"
        case state
        case isSlotInstance = "is_slot_instance"
        case parent, locations
        case startDatetimeUTC = "start_datetime_utc"
        case period
        case openHoursAppointmentApprovalProcess = "open_hours_appointment_approval_process"
    }
}






// MARK: - Exception
struct Exception: Codable {
    let pivot: Pivot?
    let lastChangedAt: String?
    let eventTypeID: Int?
    let isSlotInstance: Bool?
    let exceptionDescription: String?
    let isRecurringInstance: Bool?
    let identifier: String?
    let sessions: String?
    let idsHistory: [JSONAny]?
    let startDatetimeUTC, timezone: String?
    let createdByType: String?
    let isAllDay: Int?
    let parentID: String?
    let createdAt: String?
    let recurrence, period: String?
    let state: String?
    let type: TypeClass?
    let originalEndDatetimeUTC, endDatetimeUTC, createdByID: String?
    let deletedAt, parentType: String?
    let updatedByType: String?
    let duration, isRecurring: Int?
    let updatedByID, title, originalStartDatetimeUTC: String?
    let isSessionInstance: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case pivot
        case lastChangedAt = "last_changed_at"
        case eventTypeID = "event_type_id"
        case isSlotInstance = "is_slot_instance"
        case exceptionDescription = "description"
        case isRecurringInstance = "is_recurring_instance"
        case identifier, sessions
        case idsHistory = "ids_history"
        case startDatetimeUTC = "start_datetime_utc"
        case timezone
        case createdByType = "created_by_type"
        case isAllDay = "is_all_day"
        case parentID = "parent_id"
        case createdAt = "created_at"
        case recurrence, period, state, type
        case originalEndDatetimeUTC = "original_end_datetime_utc"
        case endDatetimeUTC = "end_datetime_utc"
        case createdByID = "created_by_id"
        case deletedAt = "deleted_at"
        case parentType = "parent_type"
        case updatedByType = "updated_by_type"
        case duration
        case isRecurring = "is_recurring"
        case updatedByID = "updated_by_id"
        case title
        case originalStartDatetimeUTC = "original_start_datetime_utc"
        case isSessionInstance = "is_session_instance"
        case id
    }
}






// MARK: - Welcome
struct OpenHourSubmissionResult: Codable {
    let startDatetimeUTC, lastChangedAt, id: String?
    let bufferBeforeSlot: Int?
    let isRecurringInstance: Bool?
    let updatedByID, createdByType, recurrence, inTimezone: String?
    let title: String?
    let isRecurring: Int?
    let deletedAt: JSONNull?
    let updatedByType: String?
    let period, sessions: JSONNull?
    let eventTypeID: Int?
    let identifier: String?
    let deadlineTimeOnDay: Int?
    let isSessionInstance: Bool?
    let idsHistory: [JSONAny]?
    let endDatetimeUTC, state: String?
    let isAllDay: Int?
    let purposes: [Purpose]?
    let endDatetime: String?
    let type: TypeClass?
    let createdBy: CreatedBy?
    let maximumMeetingsPerDay, duration: Int?
    let welcomeDescription: String?
    let calendars: [JSONAny]?
    let slotDuration: String?
    let locations: [Location]?
    let parentID: JSONNull?
    let timezone, createdByID: String?
    let parentType: JSONNull?
    let deadlineDaysBefore: Int?
    let startDatetime, createdAt: String?
    let isSlotInstance: Bool?
    let openHoursAppointmentApprovalProcess: String?

    enum CodingKeys: String, CodingKey {
        case startDatetimeUTC = "start_datetime_utc"
        case lastChangedAt = "last_changed_at"
        case id
        case bufferBeforeSlot = "buffer_before_slot"
        case isRecurringInstance = "is_recurring_instance"
        case updatedByID = "updated_by_id"
        case createdByType = "created_by_type"
        case recurrence
        case inTimezone = "in_timezone"
        case title
        case isRecurring = "is_recurring"
        case deletedAt = "deleted_at"
        case updatedByType = "updated_by_type"
        case period, sessions
        case eventTypeID = "event_type_id"
        case identifier
        case deadlineTimeOnDay = "deadline_time_on_day"
        case isSessionInstance = "is_session_instance"
        case idsHistory = "ids_history"
        case endDatetimeUTC = "end_datetime_utc"
        case state
        case isAllDay = "is_all_day"
        case purposes
        case endDatetime = "end_datetime"
        case type
        case createdBy = "created_by"
        case maximumMeetingsPerDay = "maximum_meetings_per_day"
        case duration
        case welcomeDescription = "description"
        case calendars
        case slotDuration = "slot_duration"
        case locations
        case parentID = "parent_id"
        case timezone
        case createdByID = "created_by_id"
        case parentType = "parent_type"
        case deadlineDaysBefore = "deadline_days_before"
        case startDatetime = "start_datetime"
        case createdAt = "created_at"
        case isSlotInstance = "is_slot_instance"
        case openHoursAppointmentApprovalProcess = "open_hours_appointment_approval_process"
    }
}




