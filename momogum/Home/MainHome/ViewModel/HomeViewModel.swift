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
    
    // 필터 버튼 데이터
    let buttonLabels: [String] = [
        "또올래요:)", "한식", "중식", "일식", "양식",
        "아시안", "패스트푸드", "카페", "기타"
    ]
    
    // 버튼 클릭 시 선택 상태 변경
    func selectButton(index: Int) {
        selectedButtonIndex = index
    }
    
    // 알림 카운트 감소 로직
    func clearNotifications() {
        unreadNotificationCount = 0
    }
}


