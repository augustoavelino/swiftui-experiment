//
//  JankenponTests.swift
//  swiftui-experimentTests
//
//  Created by Augusto Avelino on 12/04/24.
//

import XCTest
@testable import swiftui_experiment

final class JankenponTests: XCTestCase {
    func test_outcome_shouldReturnPlayerOneAsWinner_whenPlayerOneOptionBeatsPlayerTwo() {
        let sut = Jankenpon(playerOne: .rock, playerTwo: .scissors)
        XCTAssertEqual(sut.outcome(), .playerOne)
    }
    
    func test_outcome_shouldReturnPlayerTwoAsWinner_whenPlayerTwoOptionBeatsPlayerOne() {
        let sut = Jankenpon(playerOne: .paper, playerTwo: .scissors)
        XCTAssertEqual(sut.outcome(), .playerTwo)
    }
    
    func test_outcome_shouldReturnDraw_whenPlayerOneOptionIsEqualToPlayerTwo() {
        let sut = Jankenpon(playerOne: .paper, playerTwo: .paper)
        XCTAssertEqual(sut.outcome(), .draw)
    }
}
