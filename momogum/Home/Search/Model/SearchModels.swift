//
//  SearchModels.swift
//  momogum
//
//  Created by 김윤진 on 2/7/25.
//

import Foundation

// 계정 모델
struct Account: Identifiable {
    let id = UUID()
    var userID: String
    var name: String
}

// 키워드 모델
struct Keyword: Identifiable {
    let id = UUID()
    var title: String
}
