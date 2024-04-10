//
//  ItemDetailView.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 10/04/24.
//

import SwiftUI
import SwiftData

struct ItemDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var item: Item
    @State var chosenText = ""
    @State var isPresentingAlert = false
    
    var body: some View {
        VStack {
            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
            List {
                ForEach(item.items) { innerItem in
                    Text(innerItem.text)
                }
            }
            Button(action: updateTimestamp, label: {
                Text("Update Timestamp")
            })
        }
        .padding(.top)
        .navigationTitle("Current Item")
        .toolbar {
            Button("Add Item") {
                chosenText = ""
                isPresentingAlert = true
            }
            .alert("New Item", isPresented: $isPresentingAlert) {
                TextField("Text", text: $chosenText)
                Button("Add") {
                    addInnerItem(withText: chosenText)
                    isPresentingAlert = false
                }
                Button("Cancel", role: .cancel) {
                    isPresentingAlert = false
                }
            }
        }
    }
    
    func updateTimestamp() {
        item.timestamp = Date()
    }
    
    func addInnerItem(withText text: String) {
        let innerItem = InnerItem(id: UUID(), text: text)
        item.items.append(innerItem)
    }
}

#Preview {
    let item = Item(timestamp: Date())
    return NavigationStack {
        ItemDetailView(item: item)
            .modelContainer(for: Item.self, inMemory: true)
    }
}
