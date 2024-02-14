//
//  filteredAssignments.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 2/10/24.
//

import Foundation


struct filterAssignments: Observable {
    var viewModel = TodosViewViewModel()
    
    var filteredAssignments: [Assignment] {
        
        if viewModel.searchQuery.isEmpty {
            return viewModel.assignments
        }
        
        let filteredAssignments = viewModel.assignments.compactMap { Assignment in
            for course in viewModel.courses {
                if Assignment.course_id == course.id {
                    let assignmentContainsQuery = course.name.range(of: viewModel.searchQuery, options: .caseInsensitive) != nil
                    let assignmentTitleContainsQuery = Assignment.name.range(of: viewModel.searchQuery, options: .caseInsensitive) != nil
                    return (assignmentContainsQuery || assignmentTitleContainsQuery) ? Assignment : nil
                }
            }
        
            
            return nil
        }
        return filteredAssignments
        
    }
}
