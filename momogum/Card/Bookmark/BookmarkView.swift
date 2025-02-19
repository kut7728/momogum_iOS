//
//  BookmarkView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct BookmarkView: View {
    var viewModel: CardViewModel
    var mealDiaryId: Int
    var onBookmarkToggled: () -> Void

    var body: some View {
        Button(action: {
            let wasBookmarked = viewModel.card.showBookmark
            viewModel.toggleBookmarkAPI(mealDiaryId: mealDiaryId)

            if !wasBookmarked {
                onBookmarkToggled()
            }
        }) {
            Image(viewModel.card.showBookmark ? "bookmark_fill" : "bookmark")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}
