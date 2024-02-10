//
//  AccountViewViewModel.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/5/24.
//

import Foundation
import FirebaseAuth

class AccountViewViewModel: ObservableObject {
    
    init() {}
    
    func logOut() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        
    }
    
}
