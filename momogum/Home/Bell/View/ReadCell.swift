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

            // 팔로우 버튼
            if type == .follow {
                Button(action: {
                    isFollowing.toggle()
                }) {
                    Text(isFollowing ? "팔로잉" : "팔로우")
                        .font(.mmg(.Caption3))
                        .foregroundColor(isFollowing ? Color.Red_2 : Color.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isFollowing ? Color.black_6 : Color.Red_2)
                        .cornerRadius(6)
                }
            }

            // 댓글 남김
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

// 알림 유형 Enum
enum NotificationType {
    case like
    case comment
    case follow
}

#Preview {
    VStack(spacing: 10) {
        ReadCell(title: "@@님이 회원님의 게시물을 좋아합니다.", message: "n일 전", time: "2일 전", type: .like, isFollowing: .constant(false))
        ReadCell(title: "@@님이 댓글을 남겼습니다.", message: "완전 맛있어보인다...🤤", time: "n분 전", type: .comment, isFollowing: .constant(false))
        ReadCell(title: "@@님이 회원님을 팔로우하기 시작했습니다.", message: "n일 전", time: "n일 전", type: .follow, isFollowing: .constant(false))
    }
    .padding()
}
