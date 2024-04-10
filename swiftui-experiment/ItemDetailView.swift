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
    @State var newText = ""
    @State var editText = ""
    @State var itemToEdit: InnerItem?
    @State var isPresentingNewAlert = false
    @State var isPresentingEditAlert = false
    
    var body: some View {
        VStack {
            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
            List {
                ForEach(item.items) { innerItem in
                    Text(innerItem.text)
                        .swipeActions(edge: .leading) {
                            Button("Rename") {
                                itemToEdit = innerItem
                                editText = innerItem.text
                                isPresentingEditAlert = true
                            }
                            .tint(.blue)
                        }
                }
                .onDelete(perform: deleteItems(at:))
            }
            Button(action: updateTimestamp) {
                Text("Update Timestamp")
            }
        }
        .padding(.top)
        .navigationTitle("Current Item")
        .toolbar {
            Button("Add Item") {
                newText = ""
                isPresentingNewAlert = true
            }
        }
        .alert("New Item", isPresented: $isPresentingNewAlert) {
            TextField("Text", text: $newText)
            Button("Add") {
                addInnerItem(withText: newText)
                isPresentingNewAlert = false
            }
            Button("Cancel", role: .cancel) {
                isPresentingNewAlert = false
            }
        }
        .alert("Update Item", isPresented: $isPresentingEditAlert) {
            TextField("New Text", text: $editText)
            Button("Confirm") {
                updateItem(text: editText)
                isPresentingEditAlert = false
            }
            Button("Cancel", role: .cancel) {
                isPresentingEditAlert = false
            }
        }
    }
    
    func updateTimestamp() {
        item.timestamp = Date()
    }
    
    func addInnerItem(withText text: String) {
        let innerItem = InnerItem(id: UUID(), text: text)
        withAnimation {
            item.items.append(innerItem)
        }
    }
    
    func updateItem(text: String) {
        guard let innerItem = itemToEdit,
            let itemIndex = item.items.firstIndex(where: { $0.id == innerItem.id }) else { return }
        item.items[itemIndex].text = text
    }
    
    func deleteItems(at offsets: IndexSet) {
        withAnimation {
            item.items.remove(atOffsets: offsets)            
        }
    }
}

#Preview {
    let item = Item(timestamp: Date())
    return NavigationStack {
        ItemDetailView(item: item)
            .modelContainer(for: Item.self, inMemory: true)
    }
}
