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

    // 네트워크 요청 함수
    func fetchMealDiaries(category: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        guard let userID = AuthManager.shared.UUID else {
            self.errorMessage = "사용자 ID를 찾을 수 없습니다."
            self.isLoading = false
            return
        }
        
        var endpoint: String
        if let category = category {
            endpoint = "\(BaseAPI)/mainpage/\(category)?userID=\(userID)"
        } else {
            endpoint = "\(BaseAPI)/mainpage/revisit?userID=\(userID)"
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
                    self.mealDiaries = decodedResponse.result.viewMealDiaryResponseList
                } catch {
                    self.errorMessage = "디코딩 오류: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}



//#Preview {
//    MealDiaryViewModel()
//}
