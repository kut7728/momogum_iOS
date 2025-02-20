//
//  FollowModel.swift
//  momogum
//
//  Created by 류한비 on 2/18/25.
//

import Foundation

struct FollowResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String // 팔로우 상태 변경 메시지
}

//MARK: - 팔로잉
struct FollowingUser: Codable, Identifiable {
    let userId: Int
    let nickname: String
    let name: String
    let profileImage: String?
    let searchQuery: String?
    
    var id: Int { userId }
}

struct FollowingListResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [FollowingUser]
}

//MARK: - 팔로워
struct Follower: Codable {
    let userId: Int
    let nickname: String
    let name: String
    let profileImage: String
    let searchQuery: String?
}

struct FollowerListResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [Follower]
}
