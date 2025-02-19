//
//  FollowModel.swift
//  momogum
//
//  Created by 류한비 on 2/18/25.
//

import Foundation

struct FollowResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String // 팔로우 상태 변경 메시지
}
