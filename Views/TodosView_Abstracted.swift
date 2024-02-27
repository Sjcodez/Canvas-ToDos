//
//  TodosView_Abstracted.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 2/24/24.
//

import SwiftUI

struct TodosView_Abstracted: View {    
    let assignmentsForCourse: [Assignment]
    let courses: [Course]
    let courseClicked: String
//    @State var dueToday: [Assignment]
    @State var dueToday: Bool = false
    @State var dueTommorow: Bool = false
    @State var restOfTheWeek: Bool = false
    @State var futureDueDates: Bool = false
    
    let mainWeekConstraint = TodosViewViewModel().getNextMonday()
    
    
    var isDueToday: Void {
        for assignment in assignmentsForCourse {
            let assignmentDueDate = translateJsonDate(dateString: assignment.due_at ?? "")
            if  assignmentDueDate < tommorow ?? Date.distantFuture && assignmentDueDate >= todayMain ?? Date.distantPast {
                dueToday = true
            }
            if assignmentDueDate < tommorow2 ?? Date.distantFuture, assignmentDueDate >= tommorow ?? Date.distantPast {
                dueTommorow = true
            }
            if assignmentDueDate >= tommorow2 ?? Date.distantPast, assignmentDueDate < mainWeekConstraint {
                restOfTheWeek = true
            }
            if assignmentDueDate > mainWeekConstraint, assignmentDueDate != Date.distantFuture{
                futureDueDates = true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                    List {
                        if dueToday {
                            Section {
                                ForEach(assignmentsForCourse, id: \.self) { assignment in
                                    let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                    if date < tommorow ?? Date() && date > Date() {
                                        IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: courses, date: date, assignmentPoints: assignment.points_possible)
                                    }
                                }
                            } header: {
                                Text("Due Today")
                                    .foregroundStyle(.red)
                            }
                        }
                        if dueTommorow {
                            Section {
                                ForEach(assignmentsForCourse, id: \.self) { assignment in
                                    let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                    if date < tommorow2 ?? Date() && date > tommorow ?? Date() {
                                        IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: courses, date: date, assignmentPoints: assignment.points_possible)
                                    }
                                }
                            } header: {
                                Text("Due Tommorow")
                                    .foregroundStyle(.blue)
                            }
                        }
                        if restOfTheWeek {
                            Section {
                                ForEach(assignmentsForCourse, id: \.self) { assignment in
                                    let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                    if date < mainWeekConstraint && date >= tommorow2 ?? Date() {
                                        IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: courses, date: date, assignmentPoints: assignment.points_possible)
                                    }
                                }
                            } header: {
                                Text("Rest Of The Week")
                            }
                        }
                        if futureDueDates {
                            Section {
                                ForEach(assignmentsForCourse, id: \.self) { assignment in
                                    let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                    if date > mainWeekConstraint && date != Date.distantFuture {
                                        IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: courses, date: date, assignmentPoints: assignment.points_possible)
                                    }
                                }
                            } header: {
                                Text("Future Due Dates")
                            }
                        }
                        if dueToday != true, dueTommorow != true, restOfTheWeek != true, futureDueDates != true {
                            Text("Your Free!! :)")
                                .bold()
                        }
                    }
                    .navigationTitle("\(courseClicked)")
                    .font(.subheadline)
                    .onAppear(perform: {
                        isDueToday
                    })

                }
            }
        }
        
    }

#Preview {
    TodosView_Abstracted(assignmentsForCourse: TodosViewViewModel().assignments, courses: TodosViewViewModel().courses, courseClicked: "Some Course")
}
