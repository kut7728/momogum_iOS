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

struct IsNewUserResponseModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: UserResultType
}

//  `enum`을 사용하여 result 타입을 구분
enum UserResultType: Codable {
    case user(UserResult) // 기존 유저 정보
    case token(TokenResult) // 신규 유저 토큰 정보

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let userResult = try? container.decode(UserResult.self) {
            self = .user(userResult)
        } else if let tokenResult = try? container.decode(TokenResult.self) {
            self = .token(tokenResult)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "UserResultType decoding failed")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .user(let userResult):
            try container.encode(userResult)
        case .token(let tokenResult):
            try container.encode(tokenResult)
        }
    }
}

//  신규 유저 정보 구조체
struct UserResult: Codable {
    let id: Int?
    let name: String
    let nickname: String?
    let about: String?
    let profileImage: String
    let newUser: Bool
}

//  기존 유저 (토큰 반환)
struct TokenResult: Codable {
    let accessToken: String
    let refreshToken: String
}
