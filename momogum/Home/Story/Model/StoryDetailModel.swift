//
//  StoryDetailModel.swift
//  momogum
//
//  Created by 서재민 on 2/15/25.
//

import Foundation
// MARK: - StoryDetailModel
struct StoryDetailModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: StoryDetailResult
}

// MARK: - Result
struct StoryDetailResult: Codable {
    let name: String
    let mealDiaryImageLinks: [String]
    let location, description: String
}
