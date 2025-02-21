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
                            if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                                print("📌 서버에서 받은 원본 JSON (디코딩 실패 원인 확인용):\n\(jsonString)")
                            }
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
        let url = "\(BaseAPI)/appointment/\(self.appointId)/invites?userId=9"
        
        do {
            self.friends = try await withCheckedThrowingContinuation {continuation in
                AF.request(url, method: .get)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: [Friend].self) { response in
                        
                        switch response.result {
                        case .success(let data):
                            continuation.resume(returning: data)
                            
                        case .failure(let error):
                            print("초대 가능한 친구 목록 반환 오류 \(response)")
                            continuation.resume(throwing: error)
                        }
                    }
                
            }
        } catch {
            print("초대 가능 친구 GET 오류: \(error.localizedDescription)")
            let tempImage = "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic_profile/default_image.png"
            self.friends = [
                Friend(nickname: "FrontHeadlock", name: "덕규", userId: 14, profileImage: tempImage, status: "Pending"),
                Friend(nickname: "kut7728", name: "쿠트", userId: 12, profileImage: tempImage, status: "Pending"),
                Friend(nickname: "hira1n", name: "세섬", userId: 13, profileImage: tempImage, status: "Pending"),
                Friend(nickname: "yun_206", name: "도리", userId: 11, profileImage: tempImage, status: "Pending"),
                Friend(nickname: "meoraeng", name: "머랭", userId: 10, profileImage: tempImage, status: "Pending"),
                Friend(nickname: "yawn11", name: "픽스", userId: 9, profileImage: "https://s3.ap-northeast-2.amazonaws.com/momogum-bucket/user-profile-images/c92dba64-1b6a-45cf-93d6-01e602e3b6bc-%E1%84%91%E1%85%B5%E1%86%A8%E1%84%89%E1%85%B3.jpeg", status: "Pending")
            ]
        }
    }
    
    
    // MARK: - 초대장 발송 및 저장소 초기화
    func createAppoint() {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        //        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let dateString = dateFormatter.string(from: self.pickedDate)  // 현재 시간을 ISO 8601 형식 문자열로 변환
        
        var pickedCardUrl: String {
            switch self.pickedCard {
            case "basic01.png" :
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/basic01.png"

            case "basic02.png" :
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/basic02.png"

            case "basic03.png" :
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/basic03.png"

            case "fun01.png" :
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/fun01.png"

            case "fun02.png" :
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/fun02.png"

            case "fun3.png" :                
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/fun3.png"

                
            case "event1.png" :
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/event1.png"
                
            case "event2.png" :
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/event2.png"

            case "event3.png" :
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/event3.png"
            
            default:
                return "https://momogum-bucket.s3.ap-northeast-2.amazonaws.com/basic/event2.png"

            }
        }
        
        let mainRequest = AppointmentName(
            name: self.appointName,
            menu: self.menuName,
            date: dateString,
            location: self.placeName,
            notes: self.note)
        
        let parm = NewApmRequest(userId: self.userId,
                                 appointmentId: self.appointId,
                                 userIds: self.pickedFriends.map { $0.userId ?? 0 },
                                 cardCategory: "BASIC",
                                 selectedCardUrl: pickedCardUrl,
                                 appointmentName: mainRequest)
        
        
        let url = "\(BaseAPI)/appointment/whole"
        
        AF.request(url,
                   method: .post,
                   parameters: parm,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type": "application/json", "Accept": "application/json"])
        
        
        .responseData { response in
            switch response.result {
            case .success(let data):
                // UTF-8로 변환
                if let utf8String = String(data: data, encoding: .utf8),
                   let utf8Data = utf8String.data(using: .utf8) {
                    do {
                        let decodedResponse = try JSONDecoder().decode(AppointCreateResponse.self, from: utf8Data)
                        print("✅ 새 약속 로딩 api - UTF-8 변환 후 디코딩 성공")
                        
                        self.newAppoint = Appoint(from: decodedResponse)
                        self.resetAppoint()
                        //                            print("⚠️ 새 약속 로딩 응답: \(decodedResponse)")
                        
                    } catch {
                        print("⚠️ 새 약속 로딩 JSON 디코딩 실패: \(error)")
                        print(" JSON 디코딩 실패 데이터 값: \(utf8String)")
                    }
                } else {
                    print("❌ 새 약속 로딩 UTF-8 변환 실패")
                }
                
            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
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

