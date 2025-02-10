//
//  AccountSearchModel.swift
//  momogum
//
//  Created by 김윤진 on 2/9/25.


import Foundation

struct AccountSearchAPIResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [AccountSearchResult]
}

struct AccountSearchResult: Codable, Identifiable {
    let id: Int
    let userName: String
    let userNickName: String
    let userImageURL: String

    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case userName
        case userNickName
        case userImageURL
    }
}

