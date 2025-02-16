//
//  UserProfileManager.swift
//  momogum
//
//  Created by 류한비 on 2/9/25.
//

import Foundation
import Alamofire

@Observable
class UserProfileManager {
    static let shared = UserProfileManager()
    private init() {}
    
    //  유저 프로필 로드
    func fetchUserProfile(userId: Int, completion: @escaping (Swift.Result<UserProfile, Error>) -> Void) {
        let url = "\(BaseAPI)/userProfiles/userId/\(userId)"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let decodedResponse):
                    if let userProfile = decodedResponse.result {
                        completion(Swift.Result.success(userProfile)) // 성공 시 UserProfile 반환
                    } else {
                        print("❌ result가 nil입니다. 서버 응답을 확인하세요!")
                        completion(Swift.Result.failure(UserProfileError.noUserProfile)) // 유저 프로필 없음
                    }
                case .failure(let error):
                    print("❌ 네트워크 오류 발생: \(error.localizedDescription)")
                    completion(Swift.Result.failure(error))
                }
            }
    }
    
    // 유저가 작성한 밥일기 로드
    func fetchMealDiaries(userId: Int, completion: @escaping (Swift.Result<[ProfileMealDiary], Error>) -> Void) {
        let url = "\(BaseAPI)/userProfiles/\(userId)/meal-diaries"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ProfileMealDiaryResponse.self) { response in
                switch response.result {
                case .success(let decodedResponse):
                    completion(.success(decodedResponse.result))
                case .failure(let error):
                    //print("❌ 밥일기 로드 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    // 북마크한 밥일기 로드
    func fetchBookmarkedMealDiaries(userId: Int, completion: @escaping (Swift.Result<[ProfileMealDiary], Error>) -> Void) {
        let url = "\(BaseAPI)/userProfiles/\(userId)/bookmarked-meal-diaries"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ProfileMealDiaryResponse.self) { response in
                switch response.result {
                case .success(let decodedResponse):
                    completion(.success(decodedResponse.result))
                case .failure(let error):
                    print("❌ 북마크한 밥일기 로드 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    // 유저 정보 편집
    func updateUserProfile(userId: Int, updatedProfile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(BaseAPI)/userProfiles/\(userId)/profile"
        let parameters: [String: Any?] = [
            "nickname": updatedProfile.nickname,
            "name": updatedProfile.name,
            "about": updatedProfile.about?.isEmpty == true ? nil : updatedProfile.about
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    print("❌ 프로필 편집 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    // 유저 프로필 이미지 업로드
}

// 유저 프로필 에러
enum UserProfileError: Error {
    case invalidURL // 잘못된 URL인 경우
    case noData // 서버에서 데이터를 못 받아온 경우
    case noUserProfile // 서버 응답에서 유저 프로필을 찾을 수 없는 경우
}
