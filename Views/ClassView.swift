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
    @State var courseClicked: String = ""
    @State var assignmentListSpecific: [Assignment] = []
    
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
                                    courseClicked = course.name
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
                if let selectedCourse = apicallFuncs.courses.first(where: { $0.name == courseClicked }) {
                    let assignmentsForCourse = apicallFuncs.assignments.filter({ $0.course_id == selectedCourse.id })
                    if !assignmentsForCourse.isEmpty {
                        TodosView_Abstracted(assignments: assignmentsForCourse, courses: apicallFuncs.courses)
                    }
                }
            }).onAppear(perform: {
                apicallFuncs.fetchCourses()
            })
        }
    }
}

#Preview
{
    ClassView()
}
