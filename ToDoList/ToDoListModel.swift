//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Halle Black on 10/31/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift


struct ToDoListModel: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var title: String
    var tododata: String
    var isComplete: Bool
    var priority: Int

    init(id: String? = nil, title: String, tododata: String, isComplete: Bool = false, priority: Int) {
        self.id = id
        self.title = title
        self.tododata = tododata
        self.isComplete = isComplete
        self.priority = priority
    }

    static func == (lhs: ToDoListModel, rhs: ToDoListModel) -> Bool {
        return lhs.id == rhs.id
    }
}

