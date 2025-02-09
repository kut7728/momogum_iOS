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

// MARK: - IsNewUserResponseModel
struct IsNewUserResponseModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: UserResult
}

// MARK: - UserResult
struct UserResult: Codable {
    let id: Int?  //  id가 null일 수 있으므로 Optional 처리
    let name: String
    let nickname: String?  //  null이 가능하므로 Optional 처리
    let about: String?  //  null이 가능하므로 Optional 처리
    let profileImage: String
    let newUser: Bool
}
