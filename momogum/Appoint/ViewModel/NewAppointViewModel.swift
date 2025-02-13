//
//  AppointViewModel.swift
//  momogum
//
//  Created by nelime on 1/21/25.
//

import SwiftUI
import Alamofire

// MARK: - Appoint Sending Data
struct SendingData: Codable {
    let name: String
    let menu: String
    let date: Date
    let place: String
    let note: String
}

// MARK: - Response Structure
struct ApiResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: ApmResult
}

struct ApmResult: Codable {
    let appointmentID: Int

    enum CodingKeys: String, CodingKey {
        case appointmentID = "appointmentId"
    }
}

// MARK: - class
@Observable
class NewAppointViewModel {
    /// 약속 7요소
    var appointName: String = ""
    var menuName: String = ""
    var pickedDate: Date = Date()
    var placeName: String = ""
    var note: String = ""
    
    var pickedFriends: [String] = []
    var pickedCard: String = ""
    
    /// 전체 친구 목록
    var friends: [String] = ["친구1", "친구2", "친구3", "친구4", "친구5", "친구6", "친구7", "친구8", "친구9", "친구10"]
    
   
    
    // MARK: - 초대장 발송 및 저장소 초기화
    func createAppoint() {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let dateString = dateFormatter.string(from: self.pickedDate)  // 현재 시간을 ISO 8601 형식 문자열로 변환

        
        let parm: Parameters = [
            "name": self.appointName,
            "menu": self.menuName,
            "date": dateString,
            "location": self.placeName,
            "notes": self.note
        ]
        
        
        let url = "\(BaseAPI)/appointment/name"
        
        AF.request(url,
                   method: .post,
                   parameters: parm,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"]).responseDecodable(of: ApiResponse.self) { [self] response in
            
            switch response.result {
            case .success(let responseBody):
                print("Response received successfully: \(responseBody)")
                self.printingForDebug()
                self.resetAppoint()
                print(responseBody.result.appointmentID)
                
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
        pickedCard = "default image"
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
