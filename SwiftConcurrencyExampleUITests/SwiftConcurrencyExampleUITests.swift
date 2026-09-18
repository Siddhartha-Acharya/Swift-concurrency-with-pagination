//
//  SwiftConcurrencyExampleUITests.swift
//  SwiftConcurrencyExampleUITests
//
//  Created by selegic mac 01 on 16/09/26.
//

import XCTest

final class SwiftConcurrencyExampleUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPostsLoadAndDisplay() throws {
           let app = XCUIApplication()
           app.launch()

           // The scroll view should appear once data loads.
           // waitForExistence polls rather than failing instantly — essential for network-backed UI.
           let scrollView = app.scrollViews["postsScrollView"]
           XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "Posts scroll view did not appear in time")

           // At least the first post's cell should exist.
           let firstCell = app.descendants(matching: .any)["postCell_1"]
           XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
       }

       func testEmptyStateNeverShowsWhenDataExists() throws {
           let app = XCUIApplication()
           app.launch()

           let emptyState = app.staticTexts["emptyStateText"]
           // We expect data to load, so emptyState should NOT persist.
           // Give it a moment, then assert it's gone.
           let scrollView = app.scrollViews["postsScrollView"]
           XCTAssertTrue(scrollView.waitForExistence(timeout: 10))
           XCTAssertFalse(emptyState.exists)
       }

       func testPaginationLoadsMoreOnScroll() throws {
           let app = XCUIApplication()
           app.launch()

           let scrollView = app.scrollViews["postsScrollView"]
           XCTAssertTrue(scrollView.waitForExistence(timeout: 10))

           // Post id 10 exists on page 1 (jsonplaceholder returns posts 1-10 for page 1, limit 10)
           let post10 = app.otherElements["postCell_10"]
           XCTAssertTrue(post10.waitForExistence(timeout: 5))

           // Swipe up to trigger the .onAppear pagination logic on the last cell
           scrollView.swipeUp()

           // Post id 11+ should now appear from page 2
           let post11 = app.otherElements["postCell_11"]
           XCTAssertTrue(post11.waitForExistence(timeout: 10), "Pagination did not load page 2")
       }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
