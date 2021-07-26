//
//  AppointmentUITests.swift
//  AppointmentUITests
//
//  Created by Anurag Bhakuni on 08/07/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import XCTest

class AppointmentUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_loginFlow_getSuccess(){
                                       
        
        let app = XCUIApplication()
        app.activate()
        let firstButton  =   app/*@START_MENU_TOKEN@*/.staticTexts["Employer Representative"]/*[[".buttons[\"Employer Representative\"].staticTexts[\"Employer Representative\"]",".staticTexts[\"Employer Representative\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        firstButton.tap();
           
        let elementsQuery = app.scrollViews.otherElements
        let emailTextField = elementsQuery.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("userpermission@getnada.com")
        
        let nextButton = app/*@START_MENU_TOKEN@*/.buttons["Next"]/*[[".scrollViews.buttons[\"Next\"]",".buttons[\"Next\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nextButton.tap()
        
        
        let passwordField = elementsQuery.secureTextFields["Password"]
        
        let label = elementsQuery.secureTextFields["Password"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        passwordField.tap()
        passwordField.typeText("@Welcome123$")
//        passwordField.typeText("@Welcome123$")
    }
    
    func test_demo(){
//
//        let app = app2
//        app.buttons["BackBlue"].tap()
//        app.buttons["Employer Representative"].tap()
//
//        let elementsQuery = app.scrollViews.otherElements
//        elementsQuery.textFields["Email"].tap()
//
//        let app2 = app
//        app2/*@START_MENU_TOKEN@*/.buttons["Next"]/*[[".scrollViews.buttons[\"Next\"]",".buttons[\"Next\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
//        passwordSecureTextField.tap()
//        passwordSecureTextField.tap()
//        elementsQuery.buttons["SHOW"].tap()
//        app2/*@START_MENU_TOKEN@*/.buttons["Sign In"]/*[[".scrollViews.buttons[\"Sign In\"]",".buttons[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
           
    }
    
    
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
