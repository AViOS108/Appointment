//
//  StudentFunctionSurvey.swift
//  Resume
//
//  Created by Anurag Bhakuni on 17/12/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation
struct StudentFunctionSurvey: Codable {
    var results: [Result]

    init() {
        self.results = [Result]()
    }
}

// MARK: - Result
struct Result: Codable {
    var id: Int
    var name, isPopular: String
    var isSelected = true
    init() {
        self.id = 0
        self.name = ""
        self.isPopular = ""


    }
   
}
