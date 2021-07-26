//
//  ResumeSurveyQuestion.swift
//  Resume
//
//  Created by Anurag Bhakuni on 16/12/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct ResumeSurveyQuestion {
    var surveyName, surveyHeader, surveyInstructions: String
    var questions: [Question]
   
    init() {
        
        self.surveyName = ""
        self.surveyHeader = ""
        self.surveyInstructions = ""
        self.questions = [Question]();

    }
    
}

// MARK: - Question
struct Question {
    var benchmarkQuestionID: Int
    var question: String
    var options, optionIDS: [String]
    var sectionID, sectionName: String?
    var questionRequired: Int
    var questionName, header: String
    var min, max: Int
    var questionUUID, type: String
    var order: Int
  
    init() {
        self.benchmarkQuestionID = 0
        self.question = ""
        self.options = [String]()
        self.optionIDS = [String]()
        self.sectionID = ""
        self.sectionName = ""
        self.questionRequired = 0
        self.questionName = ""
        self.header = ""
        self.min = 0
        self.max = 0
        self.questionUUID = ""
        self.type = ""
        self.order = 0


    }
    
}
