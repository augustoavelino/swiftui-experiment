//
//  Item.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 10/04/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
