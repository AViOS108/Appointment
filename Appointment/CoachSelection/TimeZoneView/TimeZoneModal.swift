
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

enum Group: String, Codable {
    case africa = "Africa"
    case america = "America"
    case antarctica = "Antarctica"
    case arctic = "Arctic"
    case asia = "Asia"
    case atlantic = "Atlantic"
    case australia = "Australia"
    case europe = "Europe"
    case indian = "Indian"
    case pacific = "Pacific"
    case utc = "UTC"
}

typealias TimeZoneArr = [TimeZoneModal]
