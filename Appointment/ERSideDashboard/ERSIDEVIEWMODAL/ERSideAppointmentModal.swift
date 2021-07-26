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
    let id: Int?
    var typeERSide : Int?
    let eventTypeID: Int?
    let title, resultDescription, timezone, startDatetimeUTC: String?
    let endDatetimeUTC: String?
    let duration: Int?
    let state, createdAt, lastChangedAt, createdByID: String?
    let createdByType, updatedByID, updatedByType: String?
    let type: String?
    let locations: [Location]?
    let participants: [Participant]?
    let appointmentCountsByDate: [AppointmentCountsByDate]?
    var parent: [Parent]?
    let calendars: [String]?
    let openHoursAppointmentApprovalProcess,  identifier: String?
    let isRecurringInstance, isSessionInstance, isSlotInstance: Bool?
    let idsHistory: [String]?
    let startDatetime, endDatetime, inTimezone: String?
    let createdBy: CreatedBy?
    let appointmentIsCompleted: Int?

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
//        case slotDuration = "slot_duration"
//       slotDuration,
        
        case appointmentIsCompleted = "appointment_is_completed"

        
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





import Foundation

// MARK: - WelcomeElement
struct ERStudentListParticipant: Codable {
    let id: Int?
    let firstName, lastName, name, email: String?
    let secondaryEmail, benchmarkName, tags, graduationDate: String?
    let graduationLabel, testCategory, sampleTaghjk: String?
    let alumniJob, preferredJob: String?
    let tagsWithDimension, products, invitedDate, signedUpStatus: String?
    let signedUpDate, hasFilledSurvey, hasOptedOut: String?
    let hasUploadedResume, signedUpID: Int?
    let recentResumeScore: Int?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, name, email
        case secondaryEmail = "secondary_email"
        case benchmarkName = "benchmark_name"
        case tags
        case graduationDate = "Graduation Date"
        case graduationLabel = "Graduation Label"
        case testCategory = "Test Category"
        case sampleTaghjk = "Sample taghjk"
        case alumniJob = "Alumni Job"
        case preferredJob = "Preferred Job"
        case tagsWithDimension = "tags_with_dimension"
        case products
        case invitedDate = "invited_date"
        case signedUpStatus = "signed_up_status"
        case signedUpDate = "signed_up_date"
        case hasFilledSurvey = "has_filled_survey"
        case hasOptedOut = "has_opted_out"
        case hasUploadedResume = "has_uploaded_resume"
        case signedUpID = "signed_up_id"
        case recentResumeScore = "recent_resume_score"
    }
}

typealias ERStudentListParticipantArr = [ERStudentListParticipant]





// MARK: - Welcome
struct ERSideOPenHourModal: Codable {
    let total: Int?
    let results: [ResultERSideOPenHourModal]?
}

// MARK: - Result
struct ResultERSideOPenHourModal: Codable {
    let isRecurringInstance: Bool?
    let location: String?
    let id: Int?
    let timezone, identifier: String?
    let appointmentConfig: AppointmentConfig?
    let createdByID: Int?
    let createdBy: CreatedBy?
    let locationType, endDatetimeUTC, endDatetime, inTimezone: String?
    let startDatetimeUTC, startDatetime: String?

    enum CodingKeys: String, CodingKey {
        case isRecurringInstance = "is_recurring_instance"
        case location, id, timezone, identifier
        case appointmentConfig = "appointment_config"
        case createdByID = "created_by_id"
        case createdBy = "created_by"
        case locationType = "location_type"
        case endDatetimeUTC = "end_datetime_utc"
        case endDatetime = "end_datetime"
        case inTimezone = "in_timezone"
        case startDatetimeUTC = "start_datetime_utc"
        case startDatetime = "start_datetime"
    }
}

// MARK: - AppointmentConfig
struct AppointmentConfig: Codable {
    var requestApprovalType:String?
    var groupSizeLimit: String?
    var bookingDeadlineDaysBefore, bookingDeadlineTimeonDay : String?
    enum CodingKeys: String, CodingKey {
        case requestApprovalType = "request_approval_type"
        case groupSizeLimit = "group_size_limit"
        case bookingDeadlineDaysBefore = "booking_deadline_days_before"
        case bookingDeadlineTimeonDay = "booking_deadline_time_on_day"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
                 self.requestApprovalType = try container.decode(String.self, forKey: .requestApprovalType)
             } catch  {
                 self.requestApprovalType = ""
             }
        
        do {
            self.groupSizeLimit = try container.decode(String.self, forKey: .groupSizeLimit)
        } catch  {
            do {
               self.groupSizeLimit = try String( container.decode(Int.self, forKey: .groupSizeLimit))
            } catch  {
                self.groupSizeLimit = ""
            }
        }
        
        do {
              self.bookingDeadlineDaysBefore = try container.decode(String.self, forKey: .bookingDeadlineDaysBefore)
        } catch  {
            self.bookingDeadlineDaysBefore = ""
        }
        do {
               self.bookingDeadlineTimeonDay = try container.decode(String.self, forKey: .bookingDeadlineTimeonDay)
        } catch  {
            self.bookingDeadlineTimeonDay = ""

        }
       
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
//        try container.encode( self.requestApprovalType, forKey: .requestApprovalType)
//        try container.encode(self.bookingDeadlineDaysBefore, forKey: .bookingDeadlineDaysBefore)
//        try container.encode(self.bookingDeadlineTimeonDay, forKey: .bookingDeadlineTimeonDay)
//        do {
//            try container.encode( self.groupSizeLimit, forKey: .groupSizeLimit)
//        } catch  {
//            try container.encode(self.groupSizeLimit, forKey: .groupSizeLimit)
//        }
    }
    
}


