//
//  isNewUserModel.swift
//  momogum
//
//  Created by 서재민 on 2/7/25.
//

import Foundation

// 로그인시 신규유저인지 아닌지 판별
struct KakaoLoginModel: Codable {
    let provider, accessToken: String
}



