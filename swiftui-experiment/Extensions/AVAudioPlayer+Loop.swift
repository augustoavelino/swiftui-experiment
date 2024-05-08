//
//  AVAudioPlayer+Loop.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 08/05/24.
//

import AVFoundation

extension AVAudioPlayer {
    enum Loop {
        case untilStopped
        case times(Int)
        
        var count: Int {
            if case .times(let count) = self {
                return count
            }
            return -1
        }
    }
    
    func setLoop(_ loop: Loop) {
        numberOfLoops = loop.count
    }
}
