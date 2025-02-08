//
//  UserProfile.swift
//  momogum
//
//  Created by 류한비 on 2/5/25.
//

import SwiftUI

struct User: Codable {
    var isSuccess: Bool
    let code: String
    var message: String
    var result: UserProfile?
    
    //    var isCurrentUser: Bool {
    //        guard let currentUserId = AuthManager.shared.currentUser?.id else { return false }
    //
    //        if id == currentUserId { // 로그인한 현재 유저일 때
    //            return true
    //        } else { // 현재 유저가 아닐 때 (다른 유저의 프로필을 볼 때)
    //            return false
    //        }
    //    }
}

struct UserProfile: Codable {
    let id: Int
    var name: String
    var nickname: String
    var about: String?
    var profileImage: String?
}

extension User {
    static var dummyUser: User = User(
        isSuccess: true,
        code: "COMMON200",
        message: "성공입니다.",
        result: UserProfile(
            id: 1,
            name: "머머금",
            nickname: "momogum._.",
            about: "오늘은 또 뭘 먹을까!? 🍔",
            profileImage: ""
        )
    )
}
