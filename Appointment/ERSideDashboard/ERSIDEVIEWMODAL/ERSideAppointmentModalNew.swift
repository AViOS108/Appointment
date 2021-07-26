// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ERSideAppointmentModalNew: Codable {
    var total: Int?
    var indexType : Int?
    var results: [ERSideAppointmentModalNewResult]?
    var sectionHeaderER : [SectionHeaderER]?
    var sectionHeaderERMyAppo : [SectionHeaderERMyAppo]?

}

// MARK: - Result
struct ERSideAppointmentModalNewResult: Codable {
    var typeERSide : Int?

  let startDatetimeUTC, locationType: String?
       let cancellationReason: String?
       let inTimezone, timezone: String?
       let coachDetails: CoachDetails?
       let location: String?
       let id: Int?
       let startDatetime, endDatetimeUTC: String?
       let coachID: Int?
       let endDatetime, state: String?
       let appointmentConfig: AppointmentConfig?
       let title: String?
    var requests: [Request]?
       let type: String?

    enum CodingKeys: String, CodingKey {
        case startDatetimeUTC = "start_datetime_utc"
        case locationType = "location_type"
        case cancellationReason = "cancellation_reason"
        case inTimezone = "in_timezone"
        case timezone
        case coachDetails = "coach_details"
        case location, id
        case startDatetime = "start_datetime"
        case endDatetimeUTC = "end_datetime_utc"
        case coachID = "coach_id"
        case endDatetime = "end_datetime"
        case state
        case appointmentConfig = "appointment_config"
        case title, requests, type
    }
}



// MARK: - CoachDetails
struct CoachDetails: Codable {
    let id: Int?
       let name: String?
       let communityID: Int?
       let communityName, email: String?

       enum CodingKeys: String, CodingKey {
           case id, name
           case communityID = "community_id"
           case communityName = "community_name"
           case email
       }
}


// MARK: - AttachmentInfo
struct AttachmentInfo: Codable {
    let fileName, mimeType: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case mimeType = "mime_type"
        case url
    }
}

// MARK: - Request
struct RequestER: Codable {
        let state: String?
       let attachmentInfo: [AttachmentInfo]?
       let id: Int?
       let targetIndustries: [String]?
       let studentID: Int?
       let purposes: [ERSidePurposeDetailNewModal]?
       let createdByID: Int?
    let reason: String?
    let targetFunctions: [String]?
       let  additionalComments : String?
       let createdByType: String?
       var hasAttended: Int?
       let studentDetails: StudentDetails?
       let appointmentID: Int?
       let targetCompanies: [String]?
        let feedback: Feedback?

    enum CodingKeys: String, CodingKey {
        case state
        case attachmentInfo = "attachment_info"
        case id
        case feedback
        case targetIndustries = "target_industries"
        case studentID = "student_id"
        case purposes
        case createdByID = "created_by_id"
        case reason
        case additionalComments = "additional_comments"
        case targetFunctions = "target_functions"
        case createdByType = "created_by_type"
        case hasAttended = "has_attended"
        case studentDetails = "student_details"
        case appointmentID = "appointment_id"
        case targetCompanies = "target_companies"
    }
}





// MARK: - Request
struct Request: Codable {
        let state: String?
       let attachmentInfo: [AttachmentInfo]?
       let id: Int?
       let targetIndustries: [String]?
       let studentID: Int?
       let purposes: [Purpose]?
       let createdByID: Int?
    let reason: String?
    let targetFunctions: [String]?
       let  additionalComments : String?
       let createdByType: String?
       var hasAttended: Int?
       let studentDetails: StudentDetails?
       let appointmentID: Int?
       let targetCompanies: [String]?
        let feedback: Feedback?

    enum CodingKeys: String, CodingKey {
        case state
        case attachmentInfo = "attachment_info"
        case id
        case feedback
        case targetIndustries = "target_industries"
        case studentID = "student_id"
        case purposes
        case createdByID = "created_by_id"
        case reason
        case additionalComments = "additional_comments"
        case targetFunctions = "target_functions"
        case createdByType = "created_by_type"
        case hasAttended = "has_attended"
        case studentDetails = "student_details"
        case appointmentID = "appointment_id"
        case targetCompanies = "target_companies"
    }
}



// MARK: - StudentDetails
struct StudentDetails: Codable {
    let lastName, communityName, email, benchmarkName: String?
    let benchmarkID, communityID, id, miUserID: Int?
    let name, firstName: String?

    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case communityName = "community_name"
        case email
        case benchmarkName = "benchmark_name"
        case benchmarkID = "benchmark_id"
        case communityID = "community_id"
        case id
        case miUserID = "mi_user_id"
        case name
        case firstName = "first_name"
    }
}



