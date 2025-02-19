//
//  NewPostViewModel.swift
//  momogum
//
//  Created by 조승연 on 1/22/25.
//

import Foundation
import SwiftUI
import Alamofire

class NewPostViewModel: ObservableObject {
    @Published var newPost = NewPostModel(selectedCategory: nil, tags: [], mealPlace: "", newExperience: "", selectedIcon: nil)
    @Published var isUploading = false
    @Published var uploadSuccess = false
    @Published var errorMessage: String?
    @Published var mealDiaryId: Int?
    var selectedImage: UIImage?
    
    func setSelectedImage(_ image: UIImage) {
        self.selectedImage = image
    }
    
    func updateSelectedCategory(_ category: String) {
        newPost.selectedCategory = category
    }
    
    func updateTags(_ tags: [String]) {
        newPost.tags = tags
    }
    
    func updateMealPlace(_ place: String) {
        newPost.mealPlace = place
    }
    
    func updateExperience(_ experience: String) {
        newPost.newExperience = experience
    }
    
    func updateSelectedIcon(_ icon: String) {
        newPost.selectedIcon = icon
    }
    
    func resetPost() {
        newPost = NewPostModel(selectedCategory: nil, tags: [], mealPlace: "", newExperience: "", selectedIcon: nil)
    }
    
    func uploadMealDiarySingleRequest(image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("🚨 이미지 변환 실패")
            completion(false)
            return
        }
        
        let url = "\(BaseAPI)/meal-diaries"
        let headers: HTTPHeaders = [
                "Content-Type": "multipart/form-data",
                "Accept": "*/*"
        ]
        
        let categoryMapping: [String: String] = [
            "한식": "KOREAN",
            "중식": "CHINESE",
            "일식": "JAPANESE",
            "양식": "WESTERN",
            "아시안": "ASIAN",
            "패스트푸드": "FAST_FOOD",
            "카페": "CAFE",
            "기타": "ETC"
        ]
        
        let foodCategory = categoryMapping[newPost.selectedCategory ?? "기타"] ?? "ETC"
        
        let revisitMapping: [String: String] = [
            "bad": "NOT_GOOD", "soso": "SO_SO", "good": "GOOD"
        ]
        let revisit = revisitMapping[newPost.selectedIcon ?? "soso"] ?? "NOT_GOOD"
        
        let keywords = newPost.tags.joined(separator: ",")

        
        let jsonRequest: [String: Any] = [
            "memberId": 1,  // 백엔드에서 자동 설정?
            "foodCategory": foodCategory,
            "keyword": keywords,
            "location": newPost.mealPlace,
            "description": newPost.newExperience,
            "revisit": revisit
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonRequest, options: []) else {
            print("🚨 JSON 변환 오류")
            print("✅ 선택된 카테고리: \(newPost.selectedCategory ?? "선택 안 됨")")
            completion(false)
            return
        }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("🚨 JSON 문자열 변환 오류")
            print("✅ 선택된 카테고리: \(newPost.selectedCategory ?? "선택 안 됨")")
            completion(false)
            return
        }

        print("📡 최종 전송할 JSON 문자열: \(jsonString)")
        
        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "files", fileName: "meal_image.jpg", mimeType: "image/jpeg")

            formData.append(jsonString.data(using: .utf8)!, withName: "request", mimeType: "application/json")

        }, to: url, method: .post, headers: headers)
        .validate()
        .responseDecodable(of: UploadResponse.self) { response in
            switch response.result {
            case .success(let result):
                print("✅ 업로드 성공: \(result)")
                if let mealDiaryId = result.result?.mealDiaryId {
                    DispatchQueue.main.async {
                        self.mealDiaryId = mealDiaryId  // ✅ mealDiaryId 저장
                    }
                }
                completion(true)
            case .failure(let error):
                if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                    print("🚨 업로드 실패: \(error.localizedDescription)")
                    print("🚨 서버 응답: \(errorString)")
                    print("✅ 변환된 foodCategory: \(foodCategory)")
                } else {
                    print("🚨 업로드 실패: \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}

struct UploadResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MealDiaryResult?
}

struct MealDiaryResult: Decodable {
    let mealDiaryId: Int
}

struct UploadImageResponse: Decodable {
    let imageUrl: String
}
