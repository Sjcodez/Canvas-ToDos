//
//  SignInView.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/5/24.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = SignInViewViewModel()
    
    var body: some View {
        VStack {
            
            SignInHeaderView(title: "Organize Your Canvas",
                             subtitle: "Stay On Top Of School", tintColor1: Color.black, tintColor2: Color.red, angle1: 45, angle2: 135)
                
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundStyle(.red)
            }
            
            // login form goes here
            Form {
                TextField("Canvas Username", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .textInputAutocapitalization(.never)
                SecureField("Canvas Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                TLButton(title: "Log In", background: .red){
                    viewModel.login()
                }
            }
            .offset(y: -40)
            .scrollContentBackground(.hidden)
            
            
            // Sign in
        }
        
    }
}

#Preview {
    SignInView()
}
