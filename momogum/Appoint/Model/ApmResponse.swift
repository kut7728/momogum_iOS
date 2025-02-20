// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let appointCreateResult = try? JSONDecoder().decode(AppointCreateResult.self, from: jsonData)

import Foundation

// MARK: - AppointCreateResult
struct ApmResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [ApmResponseResult]
}

// MARK: - Result
struct ApmResponseResult: Codable {
    let appointmentId: Int
    let senderId: Int?
    let senderName: String?
    let fixed: String?
    
    let name, menu, date: String
    let location : String
    let notes: String?
    let createdAt: String?
    
    let selectedCards: [SelectedCard]
    let invitedFriends: [Friend]
}

// MARK: - SelectedCard
struct SelectedCard: Codable {
    let category, imageUrl: String
}
