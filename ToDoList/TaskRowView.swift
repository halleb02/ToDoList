//
//  TaskRowView.swift
//  ToDoList
//
//  Created by Halle Black on 11/16/24.
//

import SwiftUI


struct TaskRowView: View {
    var item: ToDoListModel
    var viewModel: ToDoListViewModel
    var isCompletedList: Bool

    var body: some View {
        HStack {
        
            Button(action: {
    
                viewModel.toggleComplete(item: item)
            }) {
                Image(systemName: item.isComplete ? "checkmark.square.fill" : "square")
                    .foregroundColor(item.isComplete ? .green : .red)
            }

            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.tododata)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Priority: \(String(repeating: "!", count: item.priority))")
                    .font(.caption)
            }

            Spacer()

        
            if isCompletedList {
                Button(action: {
                    viewModel.deleteItem(item: item)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .padding(.leading, 8)
            }
        }
        .padding()
    }
}
