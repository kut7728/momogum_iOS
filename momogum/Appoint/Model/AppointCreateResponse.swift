//
//  AppointCreateResult.swift
//  momogum
//
//  Created by nelime on 2/20/25.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let appointCreateResult = try? JSONDecoder().decode(AppointCreateResult.self, from: jsonData)

import Foundation

// MARK: - AppointCreateResult
struct AppointCreateResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: ACRResult
}

// MARK: - Result
struct ACRResult: Codable {
    let name, menu, date, location: String
    let notes, createdAt: String
    let invitedFriends: [Friend]
    let selectedCards: [SelectedCard]
    let appointmentId: Int
}
