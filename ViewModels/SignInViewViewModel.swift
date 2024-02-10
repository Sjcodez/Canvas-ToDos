//
//  SignInViewViewModel.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/8/24.
//

import Foundation
import FirebaseAuth



class SignInViewViewModel: ObservableObject {
    // something that takes text field data and puts it inside variables in this class
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
        
    init() {}
    
    // some function to log us in
    func login(){
        guard validate() else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password)
        return
        

    }
    
    // some function to validate the information sent by the user
    func validate() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            errorMessage = "Please Fill In All Fields"
            
            return false
        }
        
        // guard for token not going through or something.
        
        return true
    }
    
}
