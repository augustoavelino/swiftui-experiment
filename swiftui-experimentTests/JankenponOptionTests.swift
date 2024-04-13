//
//  JankenponOptionTests.swift
//  swiftui-experimentTests
//
//  Created by Augusto Avelino on 12/04/24.
//

import XCTest
@testable import swiftui_experiment

final class JankenponOptionTests: XCTestCase {
    func test_beats_shouldReturnScissors_whenOptionIsRock() {
        let option = Jankenpon.Option.rock
        XCTAssertEqual(option.beats, .scissors)
    }
    
    func test_beats_shouldReturnRock_whenOptionIsPaper() {
        let option = Jankenpon.Option.paper
        XCTAssertEqual(option.beats, .rock)
    }
    
    func test_beats_shouldReturnPaper_whenOptionIsScissors() {
        let option = Jankenpon.Option.scissors
        XCTAssertEqual(option.beats, .paper)
    }
    
    func test_losesTo_shouldReturnPaper_whenOptionIsRock() {
        let option = Jankenpon.Option.rock
        XCTAssertEqual(option.losesTo, .paper)
    }
    
    func test_losesTo_shouldReturnScissors_whenOptionIsPaper() {
        let option = Jankenpon.Option.paper
        XCTAssertEqual(option.losesTo, .scissors)
    }
    
    func test_losesTo_shouldReturnRock_whenOptionIsScissors() {
        let option = Jankenpon.Option.scissors
        XCTAssertEqual(option.losesTo, .rock)
    }
}
