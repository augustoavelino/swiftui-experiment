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
    let id: UUID
    var timestamp: Date
    var items: [InnerItem] = []
    
    init(timestamp: Date) {
        self.id = UUID()
        self.timestamp = timestamp
    }
}
