//
//  Extensions.swift
//  Canvas To-dos
//
//  Created by Sanjith Ponnusamy on 1/8/24.
//

import Foundation


extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }

    }
}



func translateJsonDate(dateString: String) -> Date {
    if dateString == "" {
        return Date.distantFuture
    } else {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "PST")
        formatter.formatOptions = [.withInternetDateTime, .withFullTime]
    //    formatter.formatOptions = [.withTime]
        let date = formatter.date(from: dateString)!
        return date
    }
    
//    String(date)
//    return date
}
