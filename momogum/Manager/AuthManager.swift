//
//  AuthManager.swift
//  momogum
//
//  Created by 서재민 on 2/11/25.
//

import Foundation

final class AuthManager : ObservableObject {
    static let shared = AuthManager()
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: UserProfile? // 유저 정보
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let accessTokenKey = "momogumAccessToken"
    private let KakaoAccessTokenKey = "kakaoAccessToken"
    private let KakaoRefreshTokenKey = "kakaoRefreshToken"
//    var UUID: Int? {
//        get {
//            let value = defaults.integer(forKey: "UUID")
//            return value == 0 ? nil : value
//        }
//        
//        set {
//            if let newValue = newValue {
//                defaults.set(newValue , forKey: "UUID")
//            } else{
//                defaults.removeObject(forKey: "UUID")
//            }
//        }
//    }
    

    var UUID: Int? {
        get {
            return 9
        }
        set {
            defaults.set(9, forKey: "UUID")
        }
    }

    //토큰 저장 키체인
    // 카카오소셜토큰값이 들어왔다가 기존 유저의 경우 isNewUser함수 실행하게 되면 해당 토큰값이 서버쪽 토큰값으로 바뀌게 된다.
    // 신규유저의 경우 isNewUser함수 실행시 토큰이 아닌 true값을 받아 회원가입 진행 후 재 로그인 진행하여 토큰값이 소셜토큰값에서 서버토큰값으로 바뀌게된다.
    var momogumAccessToken: String? {
            get {
                return KeychainHelper.shared.get(forKey: accessTokenKey)
            }
            set {
                if let token = newValue {
                    KeychainHelper.shared.save(token, forKey: accessTokenKey)
                } else {
                    KeychainHelper.shared.delete(forKey: accessTokenKey)
                }
            }
        }
    var KakaoAccessToken: String? {
            get {
                return KeychainHelper.shared.get(forKey: accessTokenKey)
            }
            set {
                if let token = newValue {
                    KeychainHelper.shared.save(token, forKey: accessTokenKey)
                } else {
                    KeychainHelper.shared.delete(forKey: accessTokenKey)
                }
            }
        }
    
    var KakaoRefreshToken: String? {
            get {
                return KeychainHelper.shared.get(forKey: accessTokenKey)
            }
            set {
                if let token = newValue {
                    KeychainHelper.shared.save(token, forKey: accessTokenKey)
                } else {
                    KeychainHelper.shared.delete(forKey: accessTokenKey)
                }
            }
        }
    func updateLoginState(isLoggedIn: Bool) {
            DispatchQueue.main.async {
                self.isLoggedIn = isLoggedIn
            }
        }
    
    
    func clearUserData() {
          defaults.removeObject(forKey: "UUID")
      }
    
    func handleLoginSuccess(userProfile: UserProfile) {
        UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
        self.currentUser = userProfile
        self.UUID = userProfile.id // 현재 유저의 UUID 저장
    }
    
    
    // 오토로그인 추후 구현예정
    func checkAutoLogin() {
        if let token = momogumAccessToken, !token.isEmpty, let userId = UUID {
                isLoggedIn = true
            // 기존에 저장된 UUID를 이용해 currentUser 설정
            self.currentUser = UserProfile(id: userId, name: "이름", nickname: "닉네임", about: nil, profileImage: nil, newUser: false)
                print("✅ 자동 로그인 성공: \(token)")
            } else {
                isLoggedIn = false
                currentUser = nil
                print("❌ 저장된 토큰 없음, 로그인 필요")
            }
        }
}
