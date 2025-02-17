//
//  HomeViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/9/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedButtonIndex: Int? = nil
    @Published var userInput: String = ""
    @Published var unreadNotificationCount: Int = 2
    @Published var selectedCategory: FoodCategory? = nil // FoodCategory enum 타입으로 변경

    let buttonLabels: [String] = ["또올래요:)"] + FoodCategory.allCases.map { $0.label }

    // 버튼 클릭 시 선택 상태 변경 + API 요청
    func selectButton(index: Int, mealDiaryViewModel: MealDiaryViewModel) {
        selectedButtonIndex = index
        let selectedLabel = buttonLabels[index]

        if selectedLabel == "또올래요:)" {
            selectedCategory = nil
            mealDiaryViewModel.resetData(category: selectedCategory) // 새로운 카테고리 선택 시 처음부터 불러오기
        } else {
            if let category = FoodCategory.fromLabel(selectedLabel) {
                selectedCategory = category
                mealDiaryViewModel.resetData(category: category) // 새로운 카테고리로 데이터 리셋
            }
        }
    }


    // 알림 카운트 감소 로직
    func clearNotifications() {
        unreadNotificationCount = 0
    }
}
