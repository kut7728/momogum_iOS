//
//  SignupViewModel.swift
//  momogum
//
//  Created by 서재민 on 1/16/25.
//

import Foundation
//Post
// 회원가입하여 새로운 계정을 생성
struct SignupModel: Codable {
    let accessToken, name, nickname: String
}



// MARK: - ResponseModel
struct SignupResponseModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: Result
    


}


// MARK: - Result
struct Result: Codable {
    let accessToken, refreshToken: String
}
