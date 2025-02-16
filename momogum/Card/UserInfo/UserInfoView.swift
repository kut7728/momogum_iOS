//
//  UserInfoView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel: MyCardViewModel

    var body: some View {
        HStack(spacing: 12) {
            if let profileImageUrl = viewModel.myCard.userProfileImageLink, let url = URL(string: profileImageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray)
                }
            } else {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.myCard.nickname)
                    .font(.system(size: 16, weight: .bold))
                Text(viewModel.myCard.mealDiaryCreatedAt)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}
