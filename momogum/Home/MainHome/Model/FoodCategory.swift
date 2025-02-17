//
//  FoodCategory.swift
//  momogum
//
//  Created by 김윤진 on 2/17/25.
//

import Foundation

// 음식 카테고리 Enum (UI Label 및 API 값 변환 포함)
enum FoodCategory: String, CaseIterable, Decodable {
    case korean = "KOREAN"
    case chinese = "CHINESE"
    case japanese = "JAPANESE"
    case western = "WESTERN"
    case asian = "ASIAN"
    case fastFood = "FAST_FOOD"
    case cafe = "CAFE"
    case etc = "ETC"

    // UI에 보여질 Label 값
    var label: String {
        switch self {
        case .korean: return "한식"
        case .chinese: return "중식"
        case .japanese: return "일식"
        case .western: return "양식"
        case .asian: return "아시안"
        case .fastFood: return "패스트푸드"
        case .cafe: return "카페"
        case .etc: return "기타"
        }
    }

    // UI Label → API 값 변환
    static func fromLabel(_ label: String) -> FoodCategory? {
        return Self.allCases.first { $0.label == label }
    }
}
