//
//  ClassView.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/5/24.
//

import SwiftUI

struct ClassView: View {
    @StateObject var apicallFuncs = TodosViewViewModel()
    
    
    var body: some View {
        Text("This is where things will be organized by class")
    }
}

#Preview {
    ClassView()
}
