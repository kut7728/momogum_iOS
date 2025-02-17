//
//  HomeViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/9/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    // UI 상태 변수
    @Published var selectedButtonIndex: Int? = nil
    @Published var userInput: String = ""
    @Published var unreadNotificationCount: Int = 2
    @Published var selectedCategory: String? = nil // 선택카테고리 값 저장
    
    // 필터 버튼 데이터
    let buttonLabels: [String] = [
        "또올래요:)", "한식", "중식", "일식", "양식",
        "아시안", "패스트푸드", "카페", "기타"
    ]
    
    // 버튼 클릭 시 선택 상태 변경 + API 요청
    func selectButton(index: Int, mealDiaryViewModel: MealDiaryViewModel) {
        selectedButtonIndex = index
        let selectedLabel = buttonLabels[index]

        // API에서 요구하는 카테고리 값으로 변환
        let category = convertToAPIParameter(selectedLabel)
        selectedCategory = category

        if selectedLabel == "또올래요:)" {
            mealDiaryViewModel.fetchMealDiaries() 
        } else {
            mealDiaryViewModel.fetchMealDiaries(category: category)
        }
    }
    
    // 알림 카운트 감소 로직
    func clearNotifications() {
        unreadNotificationCount = 0
    }
    
    private func convertToAPIParameter(_ label: String) -> String {
        switch label {
        case "한식": return "KOREA"
        case "중식": return "CHINA"
        case "일식": return "JAPAN"
        case "양식": return "WESTERN"
        case "아시안": return "ASIAN"
        case "패스트푸드": return "FASTFOOD"
        case "카페": return "CAFE"
        default: return "ETC"
        }
    }
}


