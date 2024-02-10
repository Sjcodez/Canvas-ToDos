//
//  ContentView.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/5/24.
//

import SwiftUI

// sorts for list filtering (in progress)

let today = Date()
let weekConstraint = Calendar.current.date(byAdding: .day, value: 8, to: today)
let monthConstraint = Calendar.current.date(byAdding: .day, value: 32, to: today)
var constraintBeingUsed: Date = Date()


struct TodosView: View {
    @StateObject var viewModel = TodosViewViewModel()
    
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
    
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.filter.isEmpty {
                    List {
                        ForEach(filteredAssignments, id: \.self) { assignment in
                            let date = translateJsonDate(dateString: assignment.due_at ?? "")
                            if date >= Date(), /*date <= weekConstraint ?? Date.distantFuture, */date != Date.distantFuture{
                                IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: viewModel.courses, date: date, assignmentPoints: assignment.points_possible)
                            }
                        }
                    }
                    .navigationTitle("Assignments")
                    // in progress
                    .searchable(text: $viewModel.searchQuery, prompt: "Search")
                    .overlay(content: {
                        if filteredAssignments.isEmpty {
                            ContentUnavailableView.search
                        }
                    })
                    // in progress
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
        
}


#Preview {
    TodosView()
}
