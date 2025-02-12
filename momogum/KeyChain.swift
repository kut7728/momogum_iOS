import Security
import Foundation

final class KeychainHelper {
    static let shared = KeychainHelper()
    
    private init() {}
    
    /// **Keychain에 값 저장**
    func save(_ value: String, forKey key: String) {
        let data = Data(value.utf8)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query) // 기존 값 삭제
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            print(" Keychain 저장 실패")
        }
    }
    
    /// **Keychain에서 값 불러오기**
    func get(forKey key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    /// **Keychain에서 값 삭제**
    func delete(forKey key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        SecItemDelete(query)
    }
}
