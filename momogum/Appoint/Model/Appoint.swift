//
//  Appointment.swift
//  momogum
//
//  Created by nelime on 1/21/25.
//

import Foundation


struct Appoint: Codable, Identifiable {
    let id: Int // 약속 고유 id
    
    var senderId: Int
    var senderName: String
    
    var appointName: String
    var menuName: String
    var pickedDate: Date
    var placeName: String
    var note: String
    
    var pickedFriends: [Friend]
    var pickedCard: String
    
    var isConfirmed: Bool = false
    
    init(id: Int, senderId: Int, senderName: String, appointName: String, menuName: String, pickedDate: Date, placeName: String, note: String, pickedFriends: [Friend], pickedCard: String, isConfirmed: Bool = false) {
            self.id = id
            self.senderId = senderId
            self.senderName = senderName
            self.appointName = appointName
            self.menuName = menuName
            self.pickedDate = pickedDate
            self.placeName = placeName
            self.note = note
            self.pickedFriends = pickedFriends
            self.pickedCard = pickedCard
            self.isConfirmed = isConfirmed
        }
    
    init(from response: ApmResponseResult) {
        self.id = response.appointmentId
        self.senderId = response.senderId ?? 0
        self.senderName = response.senderName ?? "temp"
        
        self.appointName = response.name
        self.menuName = response.menu
        self.placeName = response.location
        self.note = response.notes
        
        // 🔥 날짜 변환: "2025-02-19T10:30:00" 형태일 경우 Date 타입으로 변환 필요
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.pickedDate = dateFormatter.date(from: response.date) ?? Date()
        
        self.pickedFriends = response.invitedFriends
        self.pickedCard = response.selectedCards.imageUrl
        
        self.isConfirmed = response.fixed?.lowercased() == "true"
    }
    
    init(from response: AppointCreateResponse) {
        let result = response.result
        
        self.id = result.appointmentId
        self.senderId = 0
        self.senderName = "temp"
        
        self.appointName = result.name
        self.menuName = result.menu
        self.placeName = result.location
        self.note = result.notes
        
        // 🔥 날짜 변환: "2025-02-19T10:30:00" 형태일 경우 Date 타입으로 변환 필요
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.pickedDate = dateFormatter.date(from: result.date) ?? Date()
        
        self.pickedFriends = result.invitedFriends
        self.pickedCard = result.selectedCards.first?.imageUrl ?? ""
        
        self.isConfirmed = false
    }
    
    
}

extension Appoint {
    static var DUMMY_APM: Appoint = Appoint(
        id: Int.random(in: 1...100000),
        senderId: 1,
        senderName: "김더미",
        
        appointName: "더미 모임",
        menuName: "쿠차라 더미 부리또",
        pickedDate: Date(),
        placeName: "마포구 더미동",
        note: "꾸밈단계 더미단계",
        
        pickedFriends: [Friend.demoFriends, Friend.demoFriends, Friend.demoFriends],
        pickedCard: "basic1"
    )
}
