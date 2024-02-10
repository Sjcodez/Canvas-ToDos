//
//  User.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/11/24.
//

import Foundation

struct User: Codable {
    let id: String
    let username: String
    let email: String
    let name: String
    let token: String
}
