//
//  TLButton.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/8/24.
//

import SwiftUI


struct TLButton: View {
    
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                
                Text(title)
                    .foregroundStyle(.white)
                    .bold()
            }
        }
        .foregroundStyle(background)
        .padding()
    }
}

#Preview {
    TLButton(title: "Log In", background: .red) {
        //Action
    }
}
