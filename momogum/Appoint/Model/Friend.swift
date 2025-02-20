//
//  AvailableFreind.swift
//  momogum
//
//  Created by nelime on 2/18/25.
//
import SwiftUI

// MARK: - 초대 가능 친구 구조체
struct Friend: Codable {
    let nickname, name: String
    let profileImage: String
    let status: String
}

extension Friend {
    static let demoFriends: Friend = Friend(nickname: "test", name: "demo", profileImage: "", status: "")
        
}

