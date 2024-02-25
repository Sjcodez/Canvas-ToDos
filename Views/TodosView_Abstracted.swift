//
//  TodosView_Abstracted.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 2/24/24.
//

import SwiftUI

struct TodosView_Abstracted: View {    
    let assignments: [Assignment]
    let courses: [Course]
//    @State var dueToday: [Assignment]
    var body: some View {
        NavigationView {
            VStack {
                    List {
                        Section {
                            ForEach(assignments, id: \.self) { assignment in
                                let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                if date < tommorow ?? Date() && date > Date() {
                                    IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: courses, date: date, assignmentPoints: assignment.points_possible)
                                }
                            }
                        } header: {
                            Text("Due Today")
                                .foregroundStyle(.red)
                        }
                        
                        Section {
                            ForEach(assignments, id: \.self) { assignment in
                                let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                if date < tommorow2 ?? Date() && date > tommorow ?? Date() {
                                    IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: courses, date: date, assignmentPoints: assignment.points_possible)
                                }
                            }
                        } header: {
                            Text("Due Tommorow")
                                .foregroundStyle(.blue)
                        }
                        
                        Section {
                            ForEach(assignments, id: \.self) { assignment in
                                let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                if date < weekConstraint ?? Date.distantFuture && date > tommorow2 ?? Date() {
                                    IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: courses, date: date, assignmentPoints: assignment.points_possible)
                                }
                            }
                        } header: {
                            Text("Rest Of The Week")
                        }
                        
                        Section {
                            ForEach(assignments, id: \.self) { assignment in
                                let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                if date > weekConstraint ?? Date.distantPast && date != Date.distantFuture {
                                    IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: courses, date: date, assignmentPoints: assignment.points_possible)
                                }
                            }
                        } header: {
                            Text("Future Due Dates")
                        }
                    }
                    .navigationTitle("Assignments")

                }
            }
        }
    }

#Preview {
    TodosView_Abstracted(assignments: TodosViewViewModel().assignments, courses: TodosViewViewModel().courses)
}
