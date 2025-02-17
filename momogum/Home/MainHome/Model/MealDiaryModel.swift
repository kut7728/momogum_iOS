//
//  MealDiaryModel.swift
//  momogum
//
//  Created by 김윤진 on 2/14/25.
//

import Foundation

// 공통 API 응답 구조
struct MealDiaryResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [MealDiary] // 배열 형태로 변경
}

// meal diary 모델
struct MealDiary: Decodable, Identifiable, Equatable {
    let id: Int
    let foodImageURLs: [String]
    let userImageURL: String
    let foodCategory: FoodCategory
    let keyWord: String // String으로 변경
    let isRevisit: RevisitStatus

    enum CodingKeys: String, CodingKey {
        case id = "mealDiaryId"
        case foodImageURLs
        case userImageURL
        case foodCategory
        case keyWord
        case isRevisit
    }
}

// 재방문 여부 Enum
enum RevisitStatus: String, Decodable {
    case good = "GOOD"
    case notGood = "NOT_GOOD"
}
