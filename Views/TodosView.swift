//
//  ContentView.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/5/24.
//

import SwiftUI

// sorts for list filtering (in progress)

let todayMain = Calendar.current.date(bySettingHour: 00, minute: 00, second: 00, of: Date())
let tommorow = Calendar.current.date(byAdding: .day, value: 1, to: todayMain ?? Date())
let tommorow2 = Calendar.current.date(byAdding: .day, value: 2, to: todayMain ?? Date())
let weekConstraint = Calendar.current.date(byAdding: .day, value: 8, to: todayMain ?? Date())
let monthConstraint = Calendar.current.date(byAdding: .day, value: 32, to: todayMain ?? Date())


struct TodosView: View {
    @StateObject var viewModel = TodosViewViewModel()
    @State var dueToday: Bool = false
    
    // works for now, but needs to be abstracted at some point (too much space taken up)
    var filteredAssignments: [Assignment] {
        
        if viewModel.searchQuery.isEmpty {
            return viewModel.assignments
        }
        
        let filteredAssignments = viewModel.assignments.compactMap { Assignment in
            for course in viewModel.courses {
                if Assignment.course_id == course.id {
                    let assignmentContainsQuery = course.name.range(of: viewModel.searchQuery, options: .caseInsensitive) != nil
                    let assignmentTitleContainsQuery = Assignment.name.range(of: viewModel.searchQuery, options: .caseInsensitive) != nil
                    return (assignmentContainsQuery || assignmentTitleContainsQuery) ? Assignment : nil
                }
            }
        
            
            return nil
        }
        return filteredAssignments

    }
    
    var isDueToday: Bool {
        for assignment in filteredAssignments {
            if translateJsonDate(dateString: assignment.due_at ?? "") < tommorow ?? Date.distantFuture, translateJsonDate(dateString: assignment.due_at ?? "") > todayMain ?? Date.distantPast {
                return true
            }
        }
        return false
    }
    
    var body: some View {
        let mainWeekConstraint = viewModel.getNextMonday()
        NavigationView {
            VStack {
                    List {
                        if isDueToday {
                            Section {
                                ForEach(filteredAssignments, id: \.self) { assignment in
                                    let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                    if date < tommorow ?? Date() && date > Date() {
                                        IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: viewModel.courses, date: date, assignmentPoints: assignment.points_possible)
                                    }
                                }
                            } header: {
                                Text("Due Today")
                                    .foregroundStyle(.red)
                                    .bold()
                            }
                        }
                        Section {
                            ForEach(filteredAssignments, id: \.self) { assignment in
                                let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                if date < tommorow2 ?? Date() && date > tommorow ?? Date() {
                                    IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: viewModel.courses, date: date, assignmentPoints: assignment.points_possible)
                                }
                            }
                        } header: {
                            Text("Due Tommorow")
                                .foregroundStyle(.blue)
                        }
                        
                        Section {
                            ForEach(filteredAssignments, id: \.self) { assignment in
                                let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                if date < mainWeekConstraint && date > tommorow2 ?? Date() {
                                    IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: viewModel.courses, date: date, assignmentPoints: assignment.points_possible)
                                }
                            }
                        } header: {
                            Text("Rest Of The Week")
                        }
                        
                        Section {
                            ForEach(filteredAssignments, id: \.self) { assignment in
                                let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                if date > mainWeekConstraint && date != Date.distantFuture {
                                    IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: viewModel.courses, date: date, assignmentPoints: assignment.points_possible)
                                }
                            }
                        } header: {
                            Text("Future Due Dates")
                        }
                    }
                    .navigationTitle("Assignments")
                    .searchable(text: $viewModel.searchQuery, prompt: "Search")
                    .overlay(content: {
                        if filteredAssignments.isEmpty {
                            ContentUnavailableView.search
                        }
                    })
                    .onAppear {
                        viewModel.fetchCourses()
                    }
                }
            }
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $viewModel.filter) {
                            Button(action: {
                                
                            }, label: {
                                Text("1 Week")
                            })
                            Button(action: {
                                // something that changes the filter constraint to 1 week, 1 month, etc...
                            }, label: {
                                Text("1 Month")
                            })
                            Button(action: {
                                // something that changes the filter constraint to 1 week, 1 month, etc...
                            }, label: {
                                Text("No Due Date")
                            })
                        }
                        .labelsHidden()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    }

                }
            }) 
        }
    }
        



#Preview {
    TodosView()
}
