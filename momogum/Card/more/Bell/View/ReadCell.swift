//
//  ReadCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct ReadCell: View {
    var title: String
    var message: String
    var time: String
    var type: NotificationType
    @Binding var isFollowing: Bool

    var body: some View {
        HStack {
            Image("pixelsImage")
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.mmg(.subheader4))
                    .foregroundColor(.black_2)

                Text(message)
                    .font(.mmg(.Caption3))
                    .foregroundColor(.black_3)

                Text(time)
                    .font(.mmg(.Caption3))
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)

            Spacer()

            if type == .follow {
                Button(action: {
                    isFollowing.toggle()
                }) {
                    Text(isFollowing ? "팔로잉" : "팔로우")
                        .font(.mmg(.Caption3))
                        .foregroundColor(isFollowing ? Color.red : Color.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isFollowing ? Color.black_6 : Color.red)
                        .cornerRadius(6)
                }
            }

            if type == .comment {
                Image("post_image")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .cornerRadius(6)
            }
        }
        .frame(width: 330, height: 72)
        .padding(.leading, 26)
        .background(Color.white)
        .cornerRadius(8)
    }
}
