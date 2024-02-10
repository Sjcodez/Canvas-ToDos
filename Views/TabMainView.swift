//
//  TabMainView.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/11/24.
//

import SwiftUI

struct TabMainView: View {
    var body: some View {
        TabView {
            TodosView()
                .tabItem {
                    Label("Assignments", systemImage: "checklist")
                }
            
            ClassView()
                .tabItem {
                    Label("Classes", systemImage: "graduationcap.circle")
                }
            
            AccountView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    TabMainView()
}
