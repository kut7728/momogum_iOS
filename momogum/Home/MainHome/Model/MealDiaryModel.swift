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
    let result: ResultData
    
    struct ResultData: Decodable {  // 중첩 구조체로 변경하여 중복 선언 문제 해결
        let viewMealDiaryResponseList: [MealDiary]
    }
}

// 식사 일기 모델
struct MealDiary: Decodable, Identifiable {
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


