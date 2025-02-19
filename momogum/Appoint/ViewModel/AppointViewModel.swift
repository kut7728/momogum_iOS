//
//  AppointViewModel.swift
//  momogum
//
//  Created by nelime on 1/23/25.
//

import Foundation
import Alamofire

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
        .responseDecodable(of: ApmResponse.self) { [self] response in
            
            switch response.result {
            case .success(let responseBody):
                print("Response received successfully: \(responseBody)")
                self.confirmedAppoints = responseBody.result.map{Appoint(from: $0)}
                print("⚠️ 확정 약속 응답: \(response)")


                
            case .failure(let error):
                print("확정된 약속 로드 Error: \(error.localizedDescription)")
                print("⚠️ 확정 약속 응답: \(response)")
                return
            }
        }
    }
    
    // MARK: - 약속잡기 메인페이지 대기 중 약속 로드
    func loadPendingAppoints() {
        
        let url = "\(BaseAPI)/appointment/\(userId)accept"
        
        AF.request(url, method: .get)
        .responseDecodable(of: ApmResponse.self) { [self] response in
            
            switch response.result {
            case .success(let responseBody):
                print("Response received successfully: \(responseBody)")
                self.pendingAppoints = responseBody.result.map{Appoint(from: $0)}
                print("⚠️ 확정 안된 약속 응답: \(response)")


                
            case .failure(let error):
                print("확정 안된 약속 로드 Error: \(error.localizedDescription)")
                print("⚠️ 확정 안된 약속 응답: \(response)")

                return
            }
        }
    }
    
    
    
    
    
    
    
    func loadMyAppoints() {
        loadConfirmedAppoints()
        loadPendingAppoints()
    }
    
}
