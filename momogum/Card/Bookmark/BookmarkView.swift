//
//  BookmarkView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct BookmarkView: View {
    @Binding var showBookmark: Bool
    var viewModel: MyCardViewModel
    var mealDiaryId: Int

    var body: some View {
        Button(action: {
            viewModel.toggleBookmarkAPI(mealDiaryId: mealDiaryId)
        }) {
            Image(viewModel.myCard.showBookmark ? "bookmark_fill" : "bookmark")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}
