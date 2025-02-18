//
//  MyStoryModel.swift
//  momogum
//
//  Created by 서재민 on 2/16/25.
//

import Foundation

// MARK: - MyStoryModel
struct MyStoryModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [MyStoryResult]
}

// MARK: - Result
struct MyStoryResult: Codable {
    let mealDiaryStoryID: Int
    let nickname: String
    let profileImageLink: String
    let mealDiaryImageLinks: String
    let viewed: Bool

    enum CodingKeys: String, CodingKey {
        case mealDiaryStoryID = "mealDiaryStoryId"
        case nickname, profileImageLink, mealDiaryImageLinks, viewed
    }
}
