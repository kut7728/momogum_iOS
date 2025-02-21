//
//  Date.swift
//  momogum
//
//  Created by 서재민 on 2/18/25.
//

import Foundation
    
extension Date {
    static func fromString(_ dateString: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // API가 UTC라면 맞춰줌
        return dateFormatter.date(from: dateString)
    }

    static func fromStringWithKST(_ dateString: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS") -> Date? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = format
           dateFormatter.locale = Locale(identifier: "ko_KR")
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // 서버가 UTC 기준이라 가정

           if let utcDate = dateFormatter.date(from: dateString) {
               let kstDate = utcDate.addingTimeInterval(9 * 60 * 60) // 9시간 추가
               return kstDate
           }
           return nil
       }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }

    func timeIntervalSince(_ otherDate: Date) -> Int {
        return Int(self.timeIntervalSince(otherDate))
    }
    
    func relativeDateString() -> String {
           let calendar = Calendar.current
           let now = Date()

           if calendar.isDateInToday(self) {
               return "오늘"
           } else if calendar.isDateInYesterday(self) {
               return "어제"
           } else if let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: now),
                     calendar.isDate(self, inSameDayAs: twoDaysAgo) {
               return "엊그제"
           } else {
               return "오늘"
           }
       }
}
