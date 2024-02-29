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
    @State var mainView: Bool = true
    @State var pastDue: Bool = false
    @State var noDueDate: Bool = false
    @State var byClass: Bool = true
    @State var byDate: Bool = false
    
    let mainWeekConstraint = TodosViewViewModel().getNextMonday()
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
        
    var dueToday: Bool {
        for assignment in filteredAssignments {
            let assignmentDueDate = translateJsonDate(dateString: assignment.due_at ?? "")
            if assignmentDueDate < tommorow ?? Date.distantFuture && assignmentDueDate >= todayMain ?? Date.distantPast {
                return true
            }
        }
        return false
    }
    
    var dueTommorow: Bool {
        for assignment in filteredAssignments {
            let assignmentDueDate = translateJsonDate(dateString: assignment.due_at ?? "")
            if assignmentDueDate < tommorow2 ?? Date() && assignmentDueDate >= tommorow ?? Date.distantPast {
                return true
            }
        }
        return false
    }
    
    var restOfTheWeek: Bool {
        for assignment in filteredAssignments {
            let assignmentDueDate = translateJsonDate(dateString: assignment.due_at ?? "")
            if assignmentDueDate < mainWeekConstraint, assignmentDueDate < tommorow2 ?? Date.distantFuture {
                return true
            }
        }
        return false
    }
    
    var futureDueDates: Bool {
        for assignment in filteredAssignments {
            let assignmentDueDate = translateJsonDate(dateString: assignment.due_at ?? "")
            if assignmentDueDate != Date.distantFuture, assignmentDueDate > mainWeekConstraint {
                return true
            }
        }
        return false
    }
    
    
    var body: some View {
        let mainWeekConstraint = viewModel.getNextMonday()
        NavigationView {
            VStack {
                if mainView {
                    List {
                        if dueToday {
                            Section {
                                ForEach(filteredAssignments, id: \.self) { assignment in
                                    let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                    if date < tommorow ?? Date() && date > todayMain ?? Date() {
                                        IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: viewModel.courses, date: date, assignmentPoints: assignment.points_possible)
                                    }
                                }
                            } header: {
                                Text("Due Today")
                                    .foregroundStyle(.red)
                                    .bold()
                            }
                        }
                        if dueTommorow {
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
                        }
                        if restOfTheWeek {
                            Section {
                                ForEach(filteredAssignments, id: \.self) { assignment in
                                    let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                    if date < mainWeekConstraint && date > tommorow2 ?? Date() {
                                        IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: viewModel.courses, date: date, assignmentPoints: assignment.points_possible)
                                    }
                                }
                            } header: {
                                Text("Rest Of The Week")
                                    .foregroundStyle(Color.green)
                            }
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
                    .onAppear(perform: {
                        viewModel.fetchCourses()
                    })
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button(action: {
                                    mainView = true
                                    pastDue = false
                                    noDueDate = false
                                }, label: {
                                    Text("Assignments")
                                    if mainView {
                                        Label {
                                            Text("Assignments")
                                        } icon: {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                })
                                Button(action: {
                                    mainView = false
                                    pastDue = true
                                    noDueDate = false
                                }) {
                                    Text("Past Due")
                                    if pastDue {
                                        Label {
                                            Text("Past Due")
                                        } icon: {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                }
                                Button(action: {
                                    mainView = false
                                    pastDue = false
                                    noDueDate = true
                                }) {
                                    Text("No Due Date")
                                    if noDueDate {
                                        Label {
                                            Text("No Due Date")
                                        } icon: {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                }
                            } label: {
                                Label(
                                    title: { Text("Filters") },
                                    icon: { Image(systemName: "line.3.horizontal.decrease.circle") }
                                )
                            }
                        }
                    
                    }
                }
                if pastDue {
                    let assignmentList = viewModel.sortPastAssignments(listOfAssignments: filteredAssignments)
                    let courseFilteredAssignmentList = viewModel.sortAssignmentsByClass(listofAssignments: assignmentList, listOfCourses: viewModel.courses)
                    List {
                        if byClass {
                            ForEach(viewModel.courses, id: \.self) { course in
                                let course_id = course.id
                                if !course.name.contains("First") {
                                    Section {
                                        ForEach(courseFilteredAssignmentList, id: \.self) { assignment in
                                            if assignment.course_id == course_id {
                                                let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                                if date < todayMain ?? Date() {
                                                    IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: viewModel.courses, date: date, assignmentPoints: assignment.points_possible)
                                                }
                                            }
                                        }
                                    } header: {
                                        Text("\(course.name)")
                                            .foregroundStyle(Color.blue)
                                            .bold()
                                    }
                                }
                                
                            }
                        }
                        if byDate {
                            // Action
                        }
                    }
                    .navigationTitle("Past Due Dates")
                    .searchable(text: $viewModel.searchQuery, prompt: "Search")
                    .overlay(content: {
                        if filteredAssignments.isEmpty {
                            ContentUnavailableView.search
                        }
                    })
                    .onAppear(perform: {
                        viewModel.fetchCourses()
                    })
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button(action: {
                                    mainView = true
                                    pastDue = false
                                    noDueDate = false
                                }, label: {
                                    Text("Assignments")
                                    if mainView {
                                        Label {
                                            Text("Assignments")
                                        } icon: {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                })
                                Button(action: {
                                    mainView = false
                                    pastDue = true
                                    noDueDate = false
                                }) {
                                    Text("Past Due")
                                    if pastDue {
                                        Label {
                                            Text("Past Due")
                                        } icon: {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                }
                                Button(action: {
                                    mainView = false
                                    pastDue = false
                                    noDueDate = true
                                }) {
                                    Text("No Due Date")
                                    if noDueDate {
                                        Label {
                                            Text("No Due Date")
                                        } icon: {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                }
                            } label: {
                                Label(
                                    title: { Text("Filters") },
                                    icon: { Image(systemName: "line.3.horizontal.decrease.circle") }
                                )
                            }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                byClass = true
                                byDate = false
                            } label: {
                                if byClass {
                                    Image(systemName: "graduationcap.circle.fill")
                                } else {
                                    Image(systemName: "graduationcap.circle")
                                }
                            }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                byDate = true
                                byClass = false
                            } label: {
                                if byDate {
                                    Image(systemName: "calendar.circle.fill")
                                } else {
                                    Image(systemName: "calendar.circle")
                                }
                            }
                        }
                    
                    }
                }
                if noDueDate {
                    let courseFilteredAssignmentList = viewModel.sortAssignmentsByClass(listofAssignments: filteredAssignments, listOfCourses: viewModel.courses)
                    List {
                        ForEach(viewModel.courses, id: \.self) { course in
                            let course_id = course.id
                            if !course.name.contains("First") {
                                Section {
                                    ForEach(courseFilteredAssignmentList, id: \.self) { assignment in
                                        let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                        let assignment_course_id = assignment.course_id
                                        if date == Date.distantFuture {
                                            if course_id == assignment_course_id {
                                                IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: viewModel.courses, date: date, assignmentPoints: assignment.points_possible)
                                            }
                                        }
                                    }
                                } header: {
                                    Text("\(course.name)")
                                        .bold()
                                        .foregroundStyle(Color.teal)
                                }
                            }
                        }
                        
                    }
                    .navigationTitle("No Due Date")
                    .searchable(text: $viewModel.searchQuery, prompt: "Search")
                    .overlay(content: {
                        if filteredAssignments.isEmpty {
                            ContentUnavailableView.search
                        }
                    })
                    .onAppear(perform: {
                        viewModel.fetchCourses()
                    })
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button(action: {
                                    mainView = true
                                    pastDue = false
                                    noDueDate = false
                                }, label: {
                                    Text("Assignments")
                                    if mainView {
                                        Label {
                                            Text("Assignments")
                                        } icon: {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                })
                                Button(action: {
                                    mainView = false
                                    pastDue = true
                                    noDueDate = false
                                }) {
                                    Text("Past Due")
                                    if pastDue {
                                        Label {
                                            Text("Past Due")
                                        } icon: {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                }
                                Button(action: {
                                    mainView = false
                                    pastDue = false
                                    noDueDate = true
                                }) {
                                    Text("No Due Date")
                                    if noDueDate {
                                        Label {
                                            Text("No Due Date")
                                        } icon: {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                }
                            } label: {
                                Label(
                                    title: { Text("Filters") },
                                    icon: { Image(systemName: "line.3.horizontal.decrease.circle") }
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}
        



#Preview {
    TodosView()
}
