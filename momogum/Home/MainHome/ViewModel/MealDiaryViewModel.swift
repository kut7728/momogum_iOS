//
//  MealDiaryViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/14/25.
//

import SwiftUI

class MealDiaryViewModel: ObservableObject {
    @Published var mealDiaries: [MealDiary] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var BaseAPI: String {
        return Bundle.main.object(forInfoDictionaryKey: "BASE_API") as? String ?? ""
    }
    
    private var currentPage: Int = 0 // 현재 페이지
    private var hasMoreData: Bool = true // 더 가져올 데이터가 있는지 여부
    
    // 네트워크 요청 함수
    func fetchMealDiaries(category: FoodCategory? = nil) {
        guard !isLoading, hasMoreData else { return } // 이미 로딩 중이거나 더 이상 데이터가 없으면 return
        
        isLoading = true
        errorMessage = nil
        
        guard let userID = AuthManager.shared.UUID else {
            self.errorMessage = "사용자 ID를 찾을 수 없습니다."
            self.isLoading = false
            return
        }
        
        let endpoint: String
        if let category = category {
            endpoint = "\(BaseAPI)/mainpage/\(category.rawValue)?userId=\(userID)&page=\(currentPage)"
        } else {
            endpoint = "\(BaseAPI)/mainpage/revisit?userId=\(userID)&page=\(currentPage)"
        }
        
        guard let url = URL(string: endpoint) else {
            self.errorMessage = "잘못된 URL"
            self.isLoading = false
            return
        }
        
        print("🔹 MealDiary API 요청 URL: \(url)") // 디버깅용 요청 URL 출력
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "네트워크 오류: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "데이터를 불러오지 못했습니다."
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(MealDiaryResponse.self, from: data)
                    
                    if decodedResponse.result.isEmpty {
                        self.hasMoreData = false // 더 이상 불러올 데이터 없음
                    } else {
                        self.mealDiaries.append(contentsOf: decodedResponse.result)
                        self.currentPage += 1 // 다음 페이지로 증가
                    }
                } catch {
                    self.errorMessage = "디코딩 오류: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    // 새로운 카테고리를 선택하면, 데이터를 초기화하고 다시 불러옴
    func resetData(category: FoodCategory? = nil) {
        self.mealDiaries = []
        self.currentPage = 0
        self.hasMoreData = true
        fetchMealDiaries(category: category)
    }
}
