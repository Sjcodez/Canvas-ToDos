//
//  TodosViewViewModel.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/5/24.
//

import Foundation
import SwiftUI

struct Course: Hashable, Codable, Identifiable {
    let id: Int
    let name: String
    let account_id: Int
}

struct Assignment: Hashable, Codable, Identifiable {
    let id: Int
    let name: String
    let due_at: String?
    let course_id: Int
    let points_possible: Int
    let has_submitted_submissions: Bool
}

struct submission: Hashable, Codable, Identifiable {
    let id: Int
    let assignment_id: Int
    let score: Double?
    let attempt: Int?
}

class TodosViewViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var assignments: [Assignment] = []
    @Published var submissions: [submission] = []
    
    @Published var filter: String = ""
    @Published var searchQuery: String = "" 
    @Published var dueToday: Bool = false
    
    private let token = "Bearer 3438~T1aCVMoZv3OaOSmDcSIieROTEudEN9ckP3Dm1Wk7t98FSYLHgpAWaGUuEzxtTlgp"
    private let tokenChino = "Bearer 3438~jvTun82RKv3EV3JB3lMX9GBzI0wCDst4J8IgionASTMBuZCeM3ndwBUXdwumJLw3"
    private let tokenAndrew = "Bearer 3438~J5b1YuQ0bvm1gSiFPtbUvShaiIvm7hBYerVhpGlfl9Mp93rIXFJavSNpd8rvL0mm"
    private let tokenAneesh = "Bearer 3438~TyCtzQQ0g2K7ElrVFRmQrHsVrUr6Abvo2T2kwxPvyavWfi5sot278dsbFQ1vG1CL"
    private let sanjithUser = "34380000000364990"
    
    func fetchCourses() {
        guard let url = URL(string: "https://canvas.instructure.com/api/v1/courses?enrollment_state=active") else {
            return
        }
                
        var request = URLRequest(url: url)
        
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "Get"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, res, err in
            guard let data = data, err == nil else {
                return
            }
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self?.courses = courses
                    for course in courses {
                        if !course.name.contains("College") {
                            self?.fetchAllAssignments(courseId: course.id)
                        }
                    }
                }
//                print(courses)
            } catch {
                print(error)
            }
        }
        
        task.resume()
//        print(assignments)
    }
    
    // fetches the assignments through looping through the indivudal course Ids
    func fetchAllAssignments(courseId: Int) {
        // firstly, loop through all course ids
        let course_id = String(courseId)

        guard let url = URL(string: "https://canvas.instructure.com/api/v1/courses/\(course_id)/assignments/?per_page=100") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "Get"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, res, err in
            guard let data = data, err == nil else {
                return
            }
            
            do {
                let assignments = try JSONDecoder().decode([Assignment].self, from: data)
                DispatchQueue.main.async {
                    self?.assignments.append(contentsOf: assignments)
                    self?.sortAssignments()
//                    self?.fetchSubmissions()
                }
//                print(assignments)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    func fetchSubmissions(courseId: Int, assignmentId: Int) {
       
        guard let url = URL(string: "https://canvas.instructure.com/api/v1/courses/\(String(courseId))/assignments/\(String(assignmentId))/submissions/\(sanjithUser)") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "Get"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, res, err in
            guard let data = data, err == nil else {
                return
            }
            do {
                let submissions = try JSONDecoder().decode([submission].self, from: data)
                DispatchQueue.main.async {
                    self?.submissions = submissions
                }
                
            } catch {
                print(error)
            }
            
        }
        print(submissions)
        task.resume()
    }
    
    func sortAssignments() {
        // doing this allows us to delete duplicate assignments when the for loop goes again in the fetch all assignments function, for every reload of the todos page.
        assignments = Array(Set(assignments))
        
        assignments.sort { Assignment1, Assignment2 in
            translateJsonDate(dateString: Assignment1.due_at ?? "") < translateJsonDate(dateString: Assignment2.due_at ?? "")
        }
    }
    
    func getNextMonday() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.weekday = 2
        let today = Calendar.current.date(bySettingHour: 00, minute: 00, second: 00, of: Date())
        return calendar.nextDate(after: today ?? Date(), matching: components, matchingPolicy: .nextTime) ?? Date.distantFuture
    }
    
    
}


