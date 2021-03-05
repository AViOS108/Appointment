
import Foundation

// MARK: - WelcomeElement
struct TimeZoneModal: Codable {
    let identifier: String
    let group: String
    let displayName, offset: String
    let keywords: [String]

    enum CodingKeys: String, CodingKey {
        case identifier, group
        case displayName = "display_name"
        case offset, keywords
    }
}


typealias TimeZoneArr = [TimeZoneModal]
