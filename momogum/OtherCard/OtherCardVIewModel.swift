//
//  OtherCardViewModel.swift
//  momogum
//
//  Created by 조승연 on 2/5/25.
//

import SwiftUI

class OtherCardViewModel: ObservableObject {
    @Published var otherCard = OtherCardModel(likeCount: 0, reviewText: "식사 후기내용", showBookmark: false)
    @Published var showPopup = false
    @Published var showReportSheet = false
    @Published var showCompletedAlert = false 

    func togglePopup() {
        withAnimation {
            showPopup.toggle()
        }
    }

    func toggleBookmark() {
        otherCard.showBookmark.toggle()
    }

    func incrementLikeCount() {
        otherCard.likeCount += 1
    }

    func resetLikeCount() {
        otherCard.likeCount = 0
    }

    func toggleReportSheet() {
        showReportSheet.toggle()
    }

    func showReportCompleted() {
        showReportSheet = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showCompletedAlert = true
        }
    }
}
