//
//  IndividualTodoView.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/8/24.
//

import SwiftUI

struct IndividualTodoView: View {
    

    let todoTitle: String
    let todoCourseId: Int
    let courses: [Course]
    let date: Date
    let assignmentPoints: Int
        
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                HStack(alignment: .center) {
                    Text(todoTitle)
                        .bold()
                    Spacer()
                    ForEach(courses, id: \.self) { course in
                        if course.id == todoCourseId {
                            let courseNameArray = course.name.components(separatedBy: " ")
                            let course_name = courseNameArray[0] + " " + courseNameArray[1]
                            Text(course_name)
                                .font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                            
                        }
                    }
                }
                HStack {
                    if date == Date.distantFuture {
                        Text("No Due Date Assigned")
                            .font(.footnote)
                            .foregroundStyle(Color.blue)
                        Spacer()
                        Text("Points:")
                            .font(.footnote)
                        Text(String(assignmentPoints))
                            .font(.footnote)
                    } else if date == Date.now{
                        Text("Due Today:")
                            .font(.footnote)
                            .foregroundStyle(Color.red)
                        Text(date, style: .date)
                            .font(.footnote)
                            .foregroundStyle(Color.red)
                        Spacer()
                        Text("Points:")
                            .font(.footnote)
                        Text(String(assignmentPoints))
                            .font(.footnote)
                    } else {
                        Text("Due:")
                            .font(.footnote)
                        Text(date, style: .date)
                            .font(.footnote)
                        Spacer()
                        Text("Points:")
                            .font(.footnote)
                        Text(String(assignmentPoints))
                            .font(.footnote)
                    }
                    
                    
                }
                
        }
            
        }
    }
}

#Preview {
    IndividualTodoView(todoTitle: "Something", todoCourseId: 123123, courses: TodosViewViewModel().courses, date: Date.now, assignmentPoints: 123123)
}
