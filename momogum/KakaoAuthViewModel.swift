//
//  KakaoAuthViewModel.swift
//  momogum
//
//  Created by 서재민 on 1/15/25.
//
import SwiftUI
import Foundation
import Combine
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon


class KakaoAuthViewModel : ObservableObject {
    
    @Published var isNewUser: Bool = true
    @Published var oauthToken: OAuthToken?
    
    func handleKakaoLogout(){
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
    
    
    
    func handleKakaoLogin(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() { // 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("❌ 카카오 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if let oauthToken = oauthToken {
                    DispatchQueue.main.async {
                        self.oauthToken = oauthToken
//                        self.checkUserStatus { isNew in
//                            self.isNewUser = isNew
                        if self.isNewUser{
                            completion(true)
                        }
//                        }
                    }
                }
            }
        } else { // 카카오 웹으로 로그인
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print("❌ 카카오 계정 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if let oauthToken = oauthToken {
                    DispatchQueue.main.async {
                        self.oauthToken = oauthToken
                        if self.isNewUser{
                            self.isNewUser = false
                            completion(true)
                            print(self.isNewUser)
                        }
                        }
                    }
                }
            }
        }
    }
    
    // 서버에서 기존 유저인지 체크하는 로직
    //미완
//    func checkUserStatus(completion: @escaping (Bool) -> Void) {
//        UserApi.shared.me { user, error in
//            if let user = user {
//                let userId = user.id
//                print("카카오 유저 ID: \(String(describing: userId))")
//                
//                // 서버에서 유저가 이미 있는지 체크 (가정)
//                // 실제 구현에서는 API 요청 필요
//                let isExistingUser = false  // 서버에서 true/false 반환한다고 가정
//                completion(!isExistingUser)
//            } else {
//                completion(true) // 기본적으로 신규 유저로 처리
//            }
//        }
//    }

        func handleHasToken(){
            
            if (AuthApi.hasToken()) {
                UserApi.shared.accessTokenInfo { (_, error) in
                    if let error = error {
                        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                            //로그인 필요
                        }
                        else {
                            //기타 에러
                        }
                    }
                    else {
                        //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    }
                }
            }
            else {
                //로그인 필요
            }
        }
        
        
