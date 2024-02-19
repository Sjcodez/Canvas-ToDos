//
//  ClassView.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/5/24.
//

import SwiftUI

struct ClassView: View {
    @StateObject var apicallFuncs = TodosViewViewModel()
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    @State var clicked: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(apicallFuncs.courses) { course in
                        if !course.name.contains("College") && !course.name.contains("Aggie") {
                            let courseNameArray = course.name.components(separatedBy: " ")
                            let course_name = courseNameArray[0] + " " + courseNameArray[1]
                            // create course object and pass in values through that
                            CourseCard(courseName: course_name, amountOfAssignments: 4)
                                .onTapGesture {
                                    clicked = true
                                }
                        }
                    }
                }
                .padding()
                        .onAppear(perform: {
                            apicallFuncs.fetchCourses()
                    })
            }
            .navigationTitle(Text("Classes"))
            .sheet(isPresented: $clicked, content: {
                List {
                    ForEach(apicallFuncs.courses) { course in
                        ForEach(apicallFuncs.assignments) { assignment in
                            if assignment.course_id == course.id {
                                let date = translateJsonDate(dateString: assignment.due_at ?? "")
                                IndividualTodoView(todoTitle: assignment.name, todoCourseId: assignment.course_id, courses: apicallFuncs.courses, date: date, assignmentPoints: assignment.points_possible)
                            }
                        }
                    }
                }
            })
        }
        
    }
}

#Preview {
    ClassView()
}
