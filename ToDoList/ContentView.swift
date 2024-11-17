//
//  ContentView.swift
//  ToDoList
//
//  Created by Halle Black on 10/31/24.
//


import SwiftUI
import FirebaseAuth



struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = ToDoListViewModel()
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    @State private var newTaskPriority = 1

    var body: some View {
        Group {
            if authViewModel.isUserAuthenticated {
                ToDoListView(
                    viewModel: viewModel,
                    newTaskTitle: $newTaskTitle,
                    newTaskDescription: $newTaskDescription,
                    newTaskPriority: $newTaskPriority
                )
            } else {
                AuthView()
            }
        }
        .onAppear {
            authViewModel.isUserAuthenticated = Auth.auth().currentUser != nil
        }
    }
}

struct ToDoListView: View {
    @ObservedObject var viewModel: ToDoListViewModel
    @Binding var newTaskTitle: String
    @Binding var newTaskDescription: String
    @Binding var newTaskPriority: Int

    var body: some View {
        VStack {
            HStack {
                TextField("New Task Title", text: $newTaskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Description", text: $newTaskDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Picker("Priority", selection: $newTaskPriority) {
                    Text("!").tag(1)
                    Text("!!").tag(2)
                    Text("!!!").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
            }

            Button("Add Task") {
                viewModel.addToDoItem(
                    title: newTaskTitle,
                    description: newTaskDescription,
                    priority: newTaskPriority
                )
                newTaskTitle = ""
                newTaskDescription = ""
                newTaskPriority = 1
            }
            .padding()

            taskSection(
                title: "Uncompleted Tasks",
                items: viewModel.items.filter { !$0.isComplete }
            )

            taskSection(
                title: "Completed Tasks",
                items: viewModel.items.filter { $0.isComplete },
                backgroundColor: .green.opacity(0.1)
            )
        }
        .onAppear {
            viewModel.fetchToDoItems()
        }
        .padding()
    }

    @ViewBuilder
    private func taskSection(title: String, items: [ToDoListModel], backgroundColor: Color = .clear) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading)
                .padding(.top)

            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                List {
                    ForEach(items.sorted { $0.priority > $1.priority }) { item in
                        TaskRowView(
                            item: item,
                            viewModel: viewModel,
                            isCompletedList: title == "Completed Tasks"
                        )
                    }
                    .onDelete { indexSet in
                        indexSet.map { items[$0] }.forEach { viewModel.deleteItem(item: $0) }
                    }
                }
                .cornerRadius(10)
            }
        }
    }
}

