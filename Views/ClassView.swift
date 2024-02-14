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
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(apicallFuncs.courses) { course in
                        if !course.name.contains("College") && !course.name.contains("Aggie") {
                            let courseNameArray = course.name.components(separatedBy: " ")
                            let course_name = courseNameArray[0] + " " + courseNameArray[1]
                            CourseCard(courseName: course_name, amountOfAssignments: 4)
                        }
                    }
                }
                .padding()
                        .onAppear(perform: {
                            apicallFuncs.fetchCourses()
                    })
            }
            .navigationTitle(Text("Classes"))
        }
        
    }
}

#Preview {
    ClassView()
}
