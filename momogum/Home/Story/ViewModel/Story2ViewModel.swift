//
//  Story2ViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/9/25.
//

import SwiftUI

class Story2ViewModel: ObservableObject {
    @Published var showReportSheet: Bool = false  // 신고 모달 상태
    @Published var showPopup: Bool = false  // 팝업 상태

    // 신고 모달 열기
    func toggleReportSheet() {
        showReportSheet.toggle()
    }

    // 팝업 열기 & 일정 시간 후 자동 닫기 가능
    func showReportPopup() {
        showPopup = true
    }

    // 팝업 닫기
    func closePopup() {
        showPopup = false
    }
}



