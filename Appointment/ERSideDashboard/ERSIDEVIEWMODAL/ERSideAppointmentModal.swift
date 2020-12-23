//
//  ERSideAppointmentModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 17/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let purpleData = try? newJSONDecoder().decode(PurpleData.self, from: jsonData)

import Foundation

// MARK: - PurpleData
struct ERSideAppointmentModal: Codable {
    var results: [ERSideAppointmentModalResult]?
    var total: Int?
    var sectionHeaderER : [SectionHeaderER]?
    var sectionHeaderERMyAppo : [SectionHeaderERMyAppo]?
}


struct SectionHeaderERMyAppo: Codable {
    var title: String?
    var index : Int?
    var isExpand : Bool?
    
}

struct SectionHeaderER: Codable {
    var date: Date!    
}

// MARK: - Result
struct ERSideAppointmentModalResult: Codable {
    let id: String?
    let eventTypeID: Int?
    let title, resultDescription, timezone, startDatetimeUTC: String?
    let endDatetimeUTC: String?
    let duration: Int?
    let state, createdAt, lastChangedAt, createdByID: String?
    let createdByType, updatedByID, updatedByType: String?
    let type: TypeClass?
    let locations: [Location]?
    let participants: [Participant]?
    let appointmentCountsByDate: [AppointmentCountsByDate]?
    var parent: [Parent]?
    let calendars: [JSONAny]?
    let openHoursAppointmentApprovalProcess, slotDuration, identifier: String?
    let isRecurringInstance, isSessionInstance, isSlotInstance: Bool?
    let idsHistory: [String]?
    let startDatetime, endDatetime, inTimezone: String?
    let createdBy: CreatedBy?
//

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
        case type, locations
        case appointmentCountsByDate = "appointment_counts_by_date"
        case parent, calendars,participants
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
    }
}

// MARK: - AppointmentCountsByDate
struct AppointmentCountsByDate: Codable {
    let id: Int?
    let eventID: String?
    let localDate: String?
    let count: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case localDate = "local_date"
        case count
    }
}




