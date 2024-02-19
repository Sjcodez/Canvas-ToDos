//
//  Todo.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/5/24.
//

import Foundation

struct Todo: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let due_at: String
    let course_id: Int
    
}

struct Todo2: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let due_at: Date
    let course_id: Int
}


