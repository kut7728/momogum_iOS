//
//  isDuplicatedModel.swift
//  momogum
//
//  Created by 서재민 on 2/9/25.
//

import Foundation

// MARK: - GET  isDuplicated


struct IsDuplicatedResponseModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: Bool
}
