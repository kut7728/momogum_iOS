//
//  BookmarkView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct BookmarkView: View {
    @Binding var showBookmark: Bool
    @State private var isBookmarked = false
    var viewModel: MyCardViewModel
    var mealDiaryId: Int
    var userId: Int

    var body: some View {
        Button(action: {
            if !isBookmarked {
                showBookmark = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showBookmark = false
                }
            }
            isBookmarked.toggle()
            viewModel.toggleBookmarkAPI(mealDiaryId: mealDiaryId)
        }) {
            Image(isBookmarked ? "bookmark_fill" : "bookmark")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}
