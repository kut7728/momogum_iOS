//
//  KeywordSearchModel.swift
//  momogum
//
//  Created by 김윤진 on 2/9/25.
//

import Foundation


struct KeywordSearchAPIResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [KeywordSearchResult]
}

struct KeywordSearchResult: Codable, Identifiable, Equatable { // Equatable 추가
    let id: Int
    let foodImageURL: String
    let userImageURL: String
    let foodName: String
    let isRevisit: String

    enum CodingKeys: String, CodingKey {
        case id = "mealDiaryId"
        case foodImageURL
        case userImageURL
        case foodName
        case isRevisit
    }

    // Equatable 프로토콜 구현 (id가 같으면 동일한 객체로 인식)
    static func == (lhs: KeywordSearchResult, rhs: KeywordSearchResult) -> Bool {
        return lhs.id == rhs.id
    }
}


