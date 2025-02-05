//
//  UserProfile.swift
//  momogum
//
//  Created by 류한비 on 2/5/25.
//

import SwiftUI

struct UserProfileResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserProfile?
}

struct UserProfile: Codable {
    let id: Int
    let name: String
    let nickname: String
    let about: String
    let profileImage: String
}

extension UserProfileResponse {
    static var dummyUser: UserProfileResponse = UserProfileResponse(
        isSuccess: true,
        code: "COMMON200",
        message: "성공입니다.",
        result: UserProfile(
            id: 1,
            name: "머머금",
            nickname: "momogum._.",
            about: "오늘은 또 뭘 먹을까!? 🍔",
            profileImage: "https://i.pinimg.com/736x/a9/3b/d2/a93bd27a389fa8247138075b99d56cab.jpg"
        )
    )
}
