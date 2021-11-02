//
//  DashBoardModel.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 18/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)


// MARK: - Welcome




struct StudentHeaderModel {
    var describtion: String?
    var title : String?
    var ImageName: String?
}


struct DashBoardModel: Codable {
    var items: [Item]
      let count: Int
}

// MARK: - Item
struct Item: Codable {
    let id: Int
    var isSeeMoreSelected = false

    let name, email: String
    let profilePicURL: String?
    let roles: [Role]
    let coachInfo: CoachInfo
    var isSelected : Bool = false
    var isTappedForOpenHour = false
    enum CodingKeys: String, CodingKey {
        case id, name, email
        case profilePicURL = "profile_pic_url"
        case roles
        case coachInfo = "coach_info"
    }
}





// MARK: - Coach
struct Coach: Codable {
    let id: Int
    let name, email: String
    let profilePicURL: String?
    let summary: String
    let headline: String
    let roleID: Int
    let roleMachineName: RoleMachineName
    let requestedResumes: [String]?
    var isSelected : Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case profilePicURL = "profile_pic_url"
        case summary, headline
        case roleID = "role_id"
        case roleMachineName = "role_machine_name"
        case requestedResumes = "requested_resumes"
    }
}


enum RoleMachineName: String, Codable {
    case careerCoach = "career_coach"
    case externalCoach = "external_coach"
}



