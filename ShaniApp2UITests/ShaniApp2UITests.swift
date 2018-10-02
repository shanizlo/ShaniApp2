//
//  ShaniApp2UITests.swift
//  ShaniApp2UITests
//
//  Created by Shani Zlotnik on 27/09/2018.
//

import XCTest

class ShaniApp2UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a faœilure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.navigationBars["ShaniApp2.TodoListVC"].buttons["Add"].tap()
        app.textFields["//TODO"].tap()
        app.textFields["//TODO"].typeText("test")
        app.buttons["Add"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 8)
        
        let testCellsQuery = tablesQuery.cells.containing(.staticText, identifier:"test")
        testCellsQuery.children(matching: .button).element(boundBy: 0).tap()
        testCellsQuery.buttons["✓"].tap()

        XCTAssertTrue(testCellsQuery.buttons["✓"].exists)
        testCellsQuery.buttons["ⓧ"].tap()
//        XCTAssertFalse(testCellsQuery.buttons["✓"].exists)
        
//        cell.children(matching: .button).element(boundBy: 0).tap()
//        tablesQuery.children(matching: .cell).element(boundBy: 4).buttons["✓"].tap()
//        cell.buttons["ⓧ"].exists
//        cell.buttons["ⓧ"].tap()
//
        
        
        
    }
    
}
