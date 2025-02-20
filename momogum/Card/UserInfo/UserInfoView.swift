//
//  UserInfoView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel: CardViewModel

    var body: some View {
        HStack(spacing: 12) {
            if let profileImageUrl = viewModel.card.userProfileImageLink, let url = URL(string: profileImageUrl) {
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
                Text(viewModel.card.nickname)
                    .font(.system(size: 16, weight: .bold))

                Text(convertToFormattedDate(viewModel.card.mealDiaryCreatedAt))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }

    private func convertToFormattedDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date) 
        } else {
            return "날짜 없음"
        }
    }
}
