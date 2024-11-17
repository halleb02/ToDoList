//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Halle Black on 10/31/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift



class ToDoListViewModel: ObservableObject {
    @Published var items: [ToDoListModel] = []
    private let db = Firestore.firestore()

    func fetchToDoItems() {
        db.collection("items").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching items: \(error)")
                return
            }
            self.items = snapshot?.documents.compactMap { document in
                try? document.data(as: ToDoListModel.self)
            } ?? []
        }
    }

    func addToDoItem(title: String, description: String, priority: Int) {
        let newItem = ToDoListModel(id: nil, title: title, tododata: description, isComplete: false, priority: priority)
        do {
            _ = try db.collection("items").addDocument(from: newItem)
        } catch {
            print("Error adding item: \(error)")
        }
    }

    func toggleComplete(item: ToDoListModel) {
        guard let id = item.id else { return }
        var updatedItem = item
        updatedItem.isComplete.toggle()
        do {
            try db.collection("items").document(id).setData(from: updatedItem)
            if let index = items.firstIndex(where: { $0.id == id }) {
                items[index] = updatedItem
            }
        } catch {
            print("Error updating item: \(error)")
        }
    }

    func deleteItem(item: ToDoListModel) {
        if let id = item.id {
            db.collection("items").document(id).delete { error in
                if let error = error {
                    print("Error deleting item: \(error)")
                } else {
                    self.items.removeAll { $0.id == id }
                }
            }
        }
    }
}

