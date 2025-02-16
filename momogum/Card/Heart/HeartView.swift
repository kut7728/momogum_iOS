//
//  HeartView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct HeartView: View {
    @ObservedObject var viewModel: MyCardViewModel

    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleLike()
            }) {
                Image(viewModel.myCard.isLiked ? "heart_fill" : "heart")
                    .resizable()
                    .frame(width: 24, height: 24)
            }

            Spacer().frame(width: 12)

            Text(viewModel.myCard.likeCount >= 99 ? "99+" : "\(viewModel.myCard.likeCount)")
                .font(.system(size: 16))
                .opacity(viewModel.myCard.likeCount > 0 ? 1 : 0)
        }
        .frame(minWidth: 50)
    }
}
