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

struct KeywordSearchResult: Codable, Identifiable {
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
}

