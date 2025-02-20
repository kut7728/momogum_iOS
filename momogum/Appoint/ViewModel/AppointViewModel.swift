//
//  AppointViewModel.swift
//  momogum
//
//  Created by nelime on 1/23/25.
//

import Foundation
import Alamofire

@Observable
class AppointViewModel {
    let userId: Int = AuthManager.shared.UUID ?? 9
    
    var pendingAppoints: [Appoint] = []
    var confirmedAppoints: [Appoint] = []
    
    init() {
        loadMyAppoints()
    }
    
    // MARK: - 약속잡기 메인페이지 확정 약속 로드
    func loadConfirmedAppoints() {
        
        let url = "\(BaseAPI)/appointment/\(userId)/confirmed"
        
        AF.request(url, method: .get)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    // UTF-8로 변환
                    if let utf8String = String(data: data, encoding: .utf8),
                       let utf8Data = utf8String.data(using: .utf8) {
                        do {
                            let decodedResponse = try JSONDecoder().decode(ApmResponse.self, from: utf8Data)
                            print("✅ 확정 약속 로딩 api - UTF-8 변환 후 디코딩 성공")
                            
                            self.confirmedAppoints = decodedResponse.result.map { Appoint(from: $0) }
//                            print("⚠️ 확정 약속 응답: \(decodedResponse)")
                            
                        } catch {
                            print("⚠️ JSON 디코딩 실패: \(error)")
//                            print(" JSON 디코딩 실패 데이터 값: \(utf8String)")
                        }
                    } else {
                        print("❌ UTF-8 변환 실패")
                    }
                    
                case .failure(let error):
                    print("❌ 요청 실패: \(error.localizedDescription)")
                    return
                }
            }
    }
    
    // MARK: - 약속잡기 메인페이지 대기 중 약속 로드
    func loadPendingAppoints() {
        
        let url = "\(BaseAPI)/appointment/\(userId)/accept"
        
        AF.request(url, method: .get)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    // UTF-8로 변환
                    if let utf8String = String(data: data, encoding: .utf8),
                       let utf8Data = utf8String.data(using: .utf8) {
                        do {
                            let decodedResponse = try JSONDecoder().decode(ApmResponse.self, from: utf8Data)
                            print("✅ 미확정 약속 로딩 api - UTF-8 변환 후 디코딩 성공")
                            
                            self.pendingAppoints = decodedResponse.result.map { Appoint(from: $0) }
                            print("⚠️ 확정 약속 응답: \(decodedResponse)")
                            
                        } catch {
                            print("⚠️ JSON 디코딩 실패: \(error)")
                            print("JSON 디코딩 실패 데이터 값: \(utf8String)")
                        }
                    } else {
                        print("❌ UTF-8 변환 실패")
                    }
                    
                case .failure(let error):
                    print("❌ 요청 실패: \(error.localizedDescription)")
                    return
                }
            }
    }
    
    
    
    
    
    
    
    func loadMyAppoints() {
        loadConfirmedAppoints()
        loadPendingAppoints()
    }
    
}
