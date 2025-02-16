//
//  MealDiaryModel.swift
//  momogum
//
//  Created by 김윤진 on 2/14/25.
//

import Foundation

// 공통 API 응답 구조
struct MealDiaryResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MealDiaryResult
}

// 공통 Result 구조
struct MealDiaryResult: Codable {
    let viewMealDiaryResponseList: [MealDiary]
}

// 식사 일기 모델
struct MealDiary: Codable, Identifiable {
    let id: Int
    let foodImageURLs: [String]
    let userImageURL: String
    let foodCategory: String
    let keyWord: [String]
    let isRevisit: String

    enum CodingKeys: String, CodingKey {
        case id = "mealDiaryId"
        case foodImageURLs
        case userImageURL
        case foodCategory
        case keyWord
        case isRevisit
    }
}

