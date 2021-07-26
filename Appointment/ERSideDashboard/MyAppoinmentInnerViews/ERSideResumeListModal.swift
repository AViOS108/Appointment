// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ERSideResumeListModal: Codable {
    let total: Int?
    let items: [ERSideResumeListModalItem]?
}

// MARK: - Item
struct ERSideResumeListModalItem: Codable {
    let id: Int?
    let firstName, lastName: String?
    let email: ERSideResumeListModalEmail?
    let rpLatestResumeID: Int?
    let rpLatestResumeScore: RpResumeScore?
    let rpLatestResumeScoreType: String?
    let rpFirstResumeID: Int?
    let rpFirstResumeScore: RpResumeScore?
    let rpFirstResumeScoreType: String?
    let rpHighestScoredResumeID: Int?
    let rpHighestScoredResumeScore: RpResumeScore?
    let rpHighestScoredResumeScoreType: String?
    let rpSummary: [ERSideResumeListModalRpSummary]?
    let invitationID: Int?
    let benchmark: ERSideResumeListModalBenchmark?
    let tags: ERSideResumeListModalTags?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case rpLatestResumeID = "rp_latest_resume_id"
        case rpLatestResumeScore = "rp_latest_resume_score"
        case rpLatestResumeScoreType = "rp_latest_resume_score_type"
        case rpFirstResumeID = "rp_first_resume_id"
        case rpFirstResumeScore = "rp_first_resume_score"
        case rpFirstResumeScoreType = "rp_first_resume_score_type"
        case rpHighestScoredResumeID = "rp_highest_scored_resume_id"
        case rpHighestScoredResumeScore = "rp_highest_scored_resume_score"
        case rpHighestScoredResumeScoreType = "rp_highest_scored_resume_score_type"
        case rpSummary = "rp_summary"
        case invitationID = "invitation_id"
        case benchmark, tags
    }
}

// MARK: - Benchmark
struct ERSideResumeListModalBenchmark: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Email
struct ERSideResumeListModalEmail: Codable {
    let primary, secondary: String?
}

enum RpResumeScore: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(RpResumeScore.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for RpResumeScore"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - RpSummary
struct ERSideResumeListModalRpSummary: Codable {
    let feedback: ERSideResumeListModalFeedback?
    let filename, lastUploadedAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case feedback, filename
        case lastUploadedAt = "last_uploaded_at"
        case id
    }
}

// MARK: - Feedback
struct ERSideResumeListModalFeedback: Codable {
    let total, type: Int?
}

// MARK: - Tags
struct ERSideResumeListModalTags: Codable {
    let graduationDate, graduationLabel, x, major: String?
    let workAuthorization: String?

    enum CodingKeys: String, CodingKey {
        case graduationDate = "Graduation Date"
        case graduationLabel = "Graduation Label"
        case x = "X"
        case major = "Major"
        case workAuthorization = "Work Authorization"
    }
}
