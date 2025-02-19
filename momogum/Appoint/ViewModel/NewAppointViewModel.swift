//
//  AppointViewModel.swift
//  momogum
//
//  Created by nelime on 1/21/25.
//

import SwiftUI
import Alamofire


// MARK: - api 응답 통합 구조체
struct ApiResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: T
}

// MARK: - 약속 고유 ID 발급 구조체
struct ApmUUID: Codable {
    let appointmentID: Int
    
    enum CodingKeys: String, CodingKey {
        case appointmentID = "appointmentId"
    }
}



// MARK: - class
@Observable
class NewAppointViewModel {
    let userId: Int = AuthManager.shared.UUID ?? 9
    var appointId: Int = 0
    /// 약속 7요소
    var appointName: String = ""
    var menuName: String = ""
    var pickedDate: Date = Date()
    var placeName: String = ""
    var note: String = ""
    
    var pickedFriends: [Friend] = []
    var pickedCard: String = ""
    
    /// 전체 친구 목록
    var friends: [Friend] = []
    
    var newAppoint: Appoint?
    
    // MARK: - 약속 고유 id 획득
    func getAppointId() async -> Void {
        let url = "\(BaseAPI)/appointment/init"
        
        do {
            self.appointId = try await withCheckedThrowingContinuation { continuation in
                AF.request(url, method: .post)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: ApiResponse<ApmUUID>.self) { response in
                        
                        switch response.result {
                        case .success(let data):
                            continuation.resume(returning: data.result.appointmentID)
                            print("약속 고유 Id : \(data.result.appointmentID)")
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
            }
        } catch {
            print("약속 id POST 오류: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 초대 가능한 친구 목록 반환
    func getAvailableFriends() async -> Void {
        let url = "\(BaseAPI)/appointment/\(self.appointId)/invites?userId=\(self.userId)"
        
        do {
            self.friends = try await withCheckedThrowingContinuation {continuation in
                AF.request(url, method: .get)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: ApiResponse<[Friend]>.self) { response in
                        
                        switch response.result {
                        case .success(let data):
                            continuation.resume(returning: data.result)
                        case .failure(let error):
                            print("초대 가능한 친구 목록 반환 오류")
                            continuation.resume(throwing: error)
                        }
                    }
            }
        } catch {
            print("초대 가능 친구 GET 오류: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - 초대장 발송 및 저장소 초기화
    func createAppoint() {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        //        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let dateString = dateFormatter.string(from: self.pickedDate)  // 현재 시간을 ISO 8601 형식 문자열로 변환
        
        let mainRequest = AppointmentName(
            name: self.appointName,
            menu: self.menuName,
            date: dateString,
            location: self.placeName,
            notes: self.note)
        
        let parm = NewApmRequest(userId: self.userId,
                                                appointmentId: self.appointId,
                                                nicknames: self.pickedFriends.map { $0.nickname },
                                                cardCategory: "BASIC",
                                                selectedCardUrl: "https://s3.amazonaws.com/cards/basic1.jpg",
                                                appointmentName: mainRequest)
                
        
        let url = "\(BaseAPI)/appointment/whole"
        
        AF.request(url,
                   method: .post,
                   parameters: parm,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type": "application/json", "Accept": "application/json"])
        .responseDecodable(of: ApmResponse.self) { [self] response in
            
            switch response.result {
            case .success(let responseBody):
                print("Response received successfully: \(responseBody)")
                print(responseBody.result.appointmentId)
                let responseData = responseBody
                self.newAppoint = Appoint(from: responseData)

                
//                self.printingForDebug()
                self.resetAppoint()
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    
    // MARK: - 새 약속잡기를 취소한 경우 저장소 초기화
    func resetAppoint() {
        appointName = ""
        menuName = ""
        pickedDate = Date()
        placeName = ""
        note = ""
        pickedFriends = []
        pickedCard = ""
    }
    
    // MARK: - 디버그를 위한 약속잡기 임시저장 데이터 출력
    func printingForDebug() {
        print(appointName)
        print(menuName)
        print(pickedDate)
        print(placeName)
        print(note)
        print(pickedFriends)
        print(pickedCard)
    }
}
