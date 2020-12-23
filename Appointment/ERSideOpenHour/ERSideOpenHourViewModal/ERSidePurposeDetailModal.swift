//
//  ERSidePurposeDetailModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 03/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct  ERSidePurposeDetailModal: Codable {
    let id: Int?
    let displayName, machineName: String?
    let createdByID, createdByType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case machineName = "machine_name"
        case createdByID = "created_by_id"
        case createdByType = "created_by_type"
    }
}

typealias  ERSidePurposeDetailModalArr = [ ERSidePurposeDetailModal]




struct ProviderModal: Codable {
    let provider: String?
    let isAvailable: Bool?

    enum CodingKeys: String, CodingKey {
        case provider
        case isAvailable = "is_available"
    }
}

typealias ProviderModalArr = [ProviderModal]


import Foundation

// MARK: - Welcome
struct StudentDetailModal: Codable {
    var total: Int?
    var items: [StudentDetailModalItem]?
}




// MARK: - Item
struct StudentDetailModalItem: Codable {
    let id: Int?
    var isSelected = false
    let firstName, lastName: String?
    let email: Email?
    let invitationID: Int?
    let benchmark: Benchmark?
    let tags: Tags?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case invitationID = "invitation_id"
        case benchmark, tags
    }
}

// MARK: - Email
struct Email: Codable {
    let primary: String?
    let secondary: String?
}

// MARK: - Tags
struct Tags: Codable {
    let graduationDate: String?
    let graduationLabel: String?
    let testCategory: String?
    let sampleTaghjk: String?

    enum CodingKeys: String, CodingKey {
        case graduationDate = "Graduation Date"
        case graduationLabel = "Graduation Label"
        case testCategory = "Test Category"
        case sampleTaghjk = "Sample taghjk"
    }
}



import Foundation

// MARK: - WelcomeElement
struct ERFilterTag: Codable {
    let id: Int?
    var isExpand : Bool = false
    
    var categoryTitle : String?
    var category, tagValues: String?
    var objTagValue : [TagValueObject]?
    
    enum CodingKeys: String, CodingKey {
        case id, category
        case tagValues = "tag_values"
    }
}

struct TagValueObject : Codable,Equatable {
    var eRFilterid: Int?
    var tagValueText : String?
    var isSelected : Bool?
    var isTag = false
    
}

typealias ERFilterTagArr = [ERFilterTag]








