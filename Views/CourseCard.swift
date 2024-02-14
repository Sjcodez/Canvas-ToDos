//
//  CourseCard.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 2/13/24.
//

import SwiftUI

struct CourseCard: View {
    
    let courseName: String
    let amountOfAssignments: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.blue).opacity(0.3)
            VStack(alignment: .leading) {
                Text(courseName)
                    .font(.title)
                    .bold()
                
                Text("\(String(amountOfAssignments)) assignments due")
                    .font(.subheadline)
            }
            .padding()
            .frame(width: 175, height: 195, alignment: .leading)
            .background(.ultraThinMaterial)
            .cornerRadius(25)
            .offset(y: -2.5)
            
        }
        .frame(width: 180)
        .frame(height: 200)
        .shadow(radius: 3)
    }
}

#Preview {
    CourseCard(courseName: "STA 108", amountOfAssignments: 4)
}
