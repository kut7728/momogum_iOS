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
    let id: Int64 // 멤버 아이디(식별자)
    var name: String // 유저 이름
    var nickname: String // 유저 닉네임
    var about: String? // 한 줄 소개
    var profileImage: String? // 프로필 이미지
    let newUser: Bool
}

// 프로필 이미지 업로드 응답 모델
struct UploadProfileImageResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let imageUrl: String?
}
