//
//  AccountSearchModel.swift
//  momogum
//
//  Created by 김윤진 on 2/9/25.
//

import Foundation

// API 응답 모델
struct AccountSearchAPIResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [AccountSearchResult]
}

// 개별 계정 검색 결과 모델
struct AccountSearchResult: Codable, Identifiable, Equatable {
    let id: Int
    let userName: String
    let userNickName: String
    let userImageURL: String
    let searchFollowName: [String]?
    let searchFollowCount: Int
    let hasStory: Bool
    let hasViewedStory: Bool
    let about: String  // 추가됨
    let follower: Int  // 추가됨
    let following: Int  // 추가됨

    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case userName
        case userNickName
        case userImageURL
        case searchFollowName
        case searchFollowCount
        case hasStory
        case hasViewedStory
        case about
        case follower
        case following
    }
}

// 검색 요청 모델
struct AccountSearchRequest: Codable {
    let query: String
    let userId: Int
}
