//
//  AccountView.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/5/24.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @StateObject var viewModel = AccountViewViewModel()
    
    var body: some View {
        NavigationStack {
            Button {
                viewModel.logOut()
            } label: {
                Text("Log Out")
                    .bold()
                    .font(.title)
            }
            .navigationTitle("User Settings")
        }
    }
}

#Preview {
    AccountView()
}
