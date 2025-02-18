//
//  UserProfile.swift
//  momogum
//
//  Created by 류한비 on 2/5/25.
//

import SwiftUI

struct User: Codable {
    var isSuccess: Bool
    var code: String
    var message: String
    var result: UserProfile?
}

// 유저 프로필 모델
struct UserProfile: Codable {
    let id: Int // 멤버 아이디(식별자)
    var name: String // 유저 이름
    var nickname: String // 유저 닉네임
    var about: String? // 한 줄 소개
    var profileImage: String? // 프로필 이미지
    let newUser: Bool
    //    var isFollowing: Bool? // 팔로우 여부
    
    // 현재 유저
    var isCurrentUser: Bool {
        guard let currentUserId = AuthManager.shared.currentUser?.id else { return false }
        
        if id == currentUserId { // 로그인한 현재 유저일 때
            return true
        } else { // 현재 유저가 아닐 때 (다른 유저의 프로필을 볼 때)
            return false
        }
    }
}

// 프로필 이미지 업로드 응답 모델
struct ProfileImageResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String? // 이미지 URL
}
