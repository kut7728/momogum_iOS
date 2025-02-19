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
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let accessTokenKey = "KakaoAccessToken"
    private let refreshTokenKey = "KakaoRefreshToken"
    private let momogumrefreshTokenKey = "momogumRefreshToken"

    var UUID: Int? {
        get {
            let value = defaults.integer(forKey: "UUID")
            return value == 0 ? nil : value
        }
        
        set {
            if let newValue = newValue {
                defaults.set(newValue , forKey: "UUID")
            } else{
                defaults.removeObject(forKey: "UUID")
            }
        }
    }
    
//    
//    var UUID: Int? {
//        get {
//            return 1
//        }
//        set {
//            defaults.set(1, forKey: "UUID")
//        }
//    }

    //토큰 저장 키체인
    // 카카오소셜토큰값이 들어왔다가 기존 유저의 경우 isNewUser함수 실행하게 되면 해당 토큰값이 서버쪽 토큰값으로 바뀌게 된다.
    // 신규유저의 경우 isNewUser함수 실행시 토큰이 아닌 true값을 받아 회원가입 진행 후 재 로그인 진행하여 토큰값이 소셜토큰값에서 서버토큰값으로 바뀌게된다.
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
    var MomogumRefreshToken: String? {
            get {
                return KeychainHelper.shared.get(forKey: refreshTokenKey)
            }
            set {
                if let token = newValue {
                    KeychainHelper.shared.save(token, forKey: refreshTokenKey)
                } else {
                    KeychainHelper.shared.delete(forKey: refreshTokenKey)
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
    
    func handleLoginSuccess() {
        UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
    }
    
    
    // 오토로그인 추후 구현예정    
    func checkAutoLogin() {
            if let token = KakaoAccessToken, !token.isEmpty {
                isLoggedIn = true
                print("✅ 자동 로그인 성공: \(token)")
            } else {
                isLoggedIn = false
                print("❌ 저장된 토큰 없음, 로그인 필요")
            }
        }
}
