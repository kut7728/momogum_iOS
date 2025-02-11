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
}
