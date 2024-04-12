//
//  ItemDetailView.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 10/04/24.
//

import SwiftUI
import SwiftData

typealias TextFieldAlertState = (isShowing: Bool, text: String)

struct ItemDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var item: Item
    @State private var newItemAlertState: TextFieldAlertState = (false, "")
    @State private var editItemAlertState: TextFieldAlertState = (false, "")
    @State private var itemToEdit: InnerItem?
    
    var body: some View {
        VStack {
            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                .padding(.bottom)
            List {
                ForEach(item.items) { innerItem in
                    Text(innerItem.text)
                        .swipeActions(edge: .leading) {
                            Button("Rename") {
                                itemToEdit = innerItem
                                editItemAlertState.text = innerItem.text
                                editItemAlertState.isShowing = true
                            }
                            .tint(.blue)
                        }
                }
                .onDelete(perform: deleteItems(at:))
            }
            Button(action: updateTimestamp) {
                Text("Update Timestamp")
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Details")
        .toolbar {
            Button("Add Item") {
                newItemAlertState = (true, "")
            }
        }
        .alert("New Item", isPresented: $newItemAlertState.isShowing) {
            TextField("Text", text: $newItemAlertState.text)
            Button("Add") {
                addInnerItem(withText: newItemAlertState.text)
                newItemAlertState.isShowing = false
            }
            Button("Cancel", role: .cancel) {
                newItemAlertState.isShowing = false
            }
        }
        .alert("Update Item", isPresented: $editItemAlertState.isShowing) {
            TextField("New Text", text: $editItemAlertState.text)
            Button("Confirm") {
                updateItem(text: editItemAlertState.text)
                editItemAlertState.isShowing = false
            }
            Button("Cancel", role: .cancel) {
                editItemAlertState.isShowing = false
            }
        }
    }
    
    private func updateTimestamp() {
        item.timestamp = Date()
    }
    
    private func addInnerItem(withText text: String) {
        let innerItem = InnerItem(id: UUID(), text: text)
        withAnimation {
            item.items.append(innerItem)
        }
    }
    
    private func updateItem(text: String) {
        guard let innerItem = itemToEdit,
            let itemIndex = item.items.firstIndex(where: { $0.id == innerItem.id }) else { return }
        item.items[itemIndex].text = text
    }
    
    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            item.items.remove(atOffsets: offsets)            
        }
    }
}

#Preview {
    let item = Item(timestamp: Date())
    return NavigationStack {
        ItemDetailView()
            .modelContainer(for: Item.self, inMemory: true)
            .environmentObject(item)
    }
}
