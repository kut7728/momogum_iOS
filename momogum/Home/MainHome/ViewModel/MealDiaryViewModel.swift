//
//  MealDiaryViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/14/25.
//

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
    
    private let baseAPI = BaseAPI
    
    // 네트워크 요청 함수 (무한 스크롤 관련 코드 제거)
    func fetchMealDiaries(category: FoodCategory? = nil) {
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil


        // AuthManager에서 UUID 가져오기
        guard let userID = AuthManager.shared.UUID else {
            self.errorMessage = "로그인이 필요합니다."
            self.isLoading = false
            return
        }

        // API 엔드포인트 설정 (page 제거됨)
        let endpoint: String
        if let category = category {
            endpoint = "\(baseAPI)/mainpage/\(category.rawValue)?userId=\(userID)"
        } else {
            endpoint = "\(baseAPI)/mainpage/revisit?userId=\(userID)"
        }

        guard let url = URL(string: endpoint) else {
            self.errorMessage = "잘못된 URL"
            self.isLoading = false
            print("❌ [오류] URL 생성 실패: \(endpoint)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                // ✅ HTTP 응답 코드 확인
                if let httpResponse = response as? HTTPURLResponse {
                    print("✅ [응답 수신] HTTP 응답 상태 코드: \(httpResponse.statusCode)")
                }

                if let error = error {
                    self.errorMessage = "네트워크 오류: \(error.localizedDescription)"
                    print("❌ [오류] 네트워크 요청 실패: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    self.errorMessage = "데이터를 불러오지 못했습니다."
                    print("❌ [오류] 응답 데이터가 비어 있습니다.")
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(MealDiaryResponse.self, from: data)
                    
                    self.mealDiaries = decodedResponse.result // 기존 데이터 유지 X, 새로 덮어쓰기
                    print("📌 [결과 저장] 총 \(self.mealDiaries.count)개 데이터 로드 완료.")
                } catch {
                    self.errorMessage = "디코딩 오류: \(error.localizedDescription)"
                    print("❌ [오류] JSON 디코딩 실패: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // 새로운 카테고리를 선택하면, 데이터를 초기화하고 다시 불러옴
    func resetData(category: FoodCategory? = nil) {
        self.mealDiaries = [] // 기존 데이터 초기화
        fetchMealDiaries(category: category)
    }
}
