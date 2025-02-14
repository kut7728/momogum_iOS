//
//  MealDiary.swift
//  momogum
//
//  Created by 류한비 on 2/14/25.
//

import Foundation

// MealDiary API 응답 모델
struct MealDiaryResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [MealDiary] // 밥일기 리스트
}

// MealDiary 모델
struct MealDiary: Codable {
    let mealDiaryId: Int64
    let foodImageURLs: [String] // 밥일기 사진
    let userImageURL: String // 유저 프로필 이미지 URL
    let foodCategory: String // 음식 카테고리
    let keyWord: [String] // 키워드 리스트
    let isRevisit: String // 또 올래요 스티커 여부
}
