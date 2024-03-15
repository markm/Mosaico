//
//  MosaicoUITests.swift
//  MosaicoUITests
//
//  Created by Mark Mckelvie on 3/12/24.
//

import XCTest
import SwiftUI
@testable import Mosaico

final class MosaicoUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testNewGameButton() {
        // Given
        let newGameButton = app.buttons["NewGameButton"]
    
        /// Simulate tap on the button
        newGameButton.tap()
        
        // Then
        XCTAssertTrue(newGameButton.exists, "NewGameButton should exist in the UI hierarchy")
    }
}
