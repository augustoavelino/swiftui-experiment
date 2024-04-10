//
//  Item.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 10/04/24.
//

import Foundation
import SwiftData

@Model
final class Item: ObservableObject {
    var timestamp: Date
    var items: [InnerItem] = []
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
