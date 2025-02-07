//
//  BellView.swift
//  momogum
//
//  Created by 김윤진 on 1/21/25.
//

import SwiftUI

struct BellView: View {
    @Environment(\.presentationMode) var presentationMode // 뒤로가기 기능
    @State private var unreadCount: Int = 2 // 알림 개수 (예제 데이터)

    // 목록 관리
    @State private var notifications: [ReadNotification] = [
        ReadNotification(id: UUID(), title: "@@님이 회원님의 게시물을 좋아합니다.", message: "n일 전", time: "2일 전", type: .like, isFollowing: false),
        ReadNotification(id: UUID(), title: "@@님이 댓글을 남겼습니다.", message: "웨이팅 많이 걸리나요?!!!!", time: "n일 전", type: .comment, isFollowing: false),
        ReadNotification(id: UUID(), title: "@@님이 회원님을 팔로우하기 시작했습니다.", message: "n일 전", time: "n일 전", type: .follow, isFollowing: false),
        ReadNotification(id: UUID(), title: "@@님이 댓글을 남겼습니다.", message: "완전 맛있어보인다...🤤", time: "n분 전", type: .comment, isFollowing: false),
        ReadNotification(id: UUID(), title: "@@님이 회원님을 팔로우하기 시작했습니다.", message: "n일 전", time: "n일 전", type: .follow, isFollowing: false)
    ]

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("읽지않음")
                        .font(.mmg(.subheader4))
                        .foregroundColor(.black)
                        .padding(.leading, 26)

                    if unreadCount > 0 {
                        ZStack {
                            Circle()
                                .fill(.Red_2)
                                .frame(width: 6, height: 6)
                        }
                        .offset(x: 0, y: -10)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 27)

                ForEach(0..<unreadCount, id: \.self) { _ in
                    NotReadCell(title: "새 댓글", message: "당신의 게시글에 새로운 댓글이 달렸습니다.", time: "5분 전")
                }
            }
            .padding(.bottom, 52)

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("최근30일")
                        .font(.mmg(.subheader4))
                        .foregroundColor(.black_2)
                        .padding(.leading, 26)
                    Spacer()
                }
                .padding(.bottom, 27)

                // 개별 셀 분리
                ForEach($notifications, id: \.id) { $notification in
                    ReadCell(
                        title: notification.title,
                        message: notification.message,
                        time: notification.time,
                        type: notification.type,
                        isFollowing: $notification.isFollowing
                    )
                }
            }

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 0) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                        .frame(width: 143)

                    Text("알림")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

// 데이터 모델
struct ReadNotification: Identifiable {
    var id: UUID
    var title: String
    var message: String
    var time: String
    var type: NotificationType
    var isFollowing: Bool
}

#Preview {
    BellView()
}
