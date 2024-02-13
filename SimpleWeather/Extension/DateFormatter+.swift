//
//  DateFormatter+.swift
//  SimpleWeather
//
//  Created by Seryun Chun on 2024/02/11.
//

import Foundation

extension DateFormatter {
    static func convertTime(_ raw: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시"
        return formatter.string(from: raw)
    }
    
    static func convertDay(_ raw: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let convertedDate = formatter.date(from: raw)
        
        formatter.dateFormat = "E"
       
        return formatter.string(from: convertedDate!)
    }
}
