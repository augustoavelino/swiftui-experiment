//
//  Jankenpon.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 12/04/24.
//

import Foundation

struct Jankenpon {
    let playerOne: Option
    let playerTwo: Option
    
    func outcome() -> Outcome {
        if playerOne == playerTwo { return .draw }
        if playerOne.beats == playerTwo { return .playerOne }
        return .playerTwo
    }
}

// MARK: - Option

extension Jankenpon {
    enum Option: String, CaseIterable {
        case rock, paper, scissors
        
        var beats: Option {
            switch self {
            case .rock: .scissors
            case .paper: .rock
            case .scissors: .paper
            }
        }
        
        var losesTo: Option {
            // Since there are only three options, each besting the next in a cycle,
            // this is necessarily true. But this calls two switch statements, so I'll replace it later.
            beats.beats
        }
    }
    
    enum Outcome: Int {
        case draw, playerOne, playerTwo
    }
}
