//
//  StudentIndustrySurvey.swift
//  Resume
//
//  Created by Anurag Bhakuni on 17/12/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation

struct StudentIndustrySurvey: Codable {
    var id: Int
    var name: String
    var isSelected = true
    
    
    init() {
        self.id = 0
        self.name = ""
    }
}

import Foundation

// MARK: - WelcomeElement
struct GlobalCompaies: Codable {
    var id: Int?
    var name, domainName: String?
    var scoreName, scoreDomainName: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case domainName = "domain_name"
        case scoreName = "score_name"
        case scoreDomainName = "score_domain_name"
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.domainName = ""
        self.scoreName = 0
        self.scoreDomainName = 0
    }
    
}

typealias GlobalCompaiesArr = [GlobalCompaies]

