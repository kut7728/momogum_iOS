//
//  BellView.swift
//  momogum
//
//  Created by 김윤진 on 1/21/25.
//

import SwiftUI

struct BellView: View {
    @Environment(\.presentationMode) var presentationMode // 뒤로가기 기능
    @StateObject private var viewModel = BellViewModel() // 뷰모델 추가

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("읽지않음")
                        .font(.mmg(.subheader4))
                        .foregroundColor(.black)
                        .padding(.leading, 26)

                    if viewModel.unreadCount > 0 {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 6, height: 6)
                        }
                        .offset(x: 0, y: -10)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 12)

                // 🔹 읽지 않은 알림 표시
                VStack(spacing: 16) {
                    ForEach(0..<viewModel.unreadCount, id: \.self) { _ in
                        NotReadCell(title: "새 댓글", message: "당신의 게시글에 새로운 댓글이 달렸습니다.", time: "5분 전")
                    }
                }
            }
            .padding(.top, 45)
            .padding(.bottom, 12)

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("최근 30일")
                        .font(.mmg(.subheader4))
                        .foregroundColor(.black_2)
                        .padding(.leading, 26)
                    Spacer()
                }
                .padding(.top, viewModel.unreadCount > 0 ? 52 : 52)

                // 🔹 읽은 알림 리스트
                LazyVStack(spacing: 16) {
                    ForEach($viewModel.notifications, id: \.id) { $notification in
                        ReadCell(
                            title: notification.title,
                            message: notification.message,
                            time: notification.time,
                            type: notification.type,
                            isFollowing: $notification.isFollowing
                        )
                        .onTapGesture {
                            viewModel.markAsRead(notification)
                        }
                    }
                }
                .padding(.bottom, 24)
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
                        .frame(width: 130)
                    
                    Text("알림")
                        .font(.mmg(.subheader3))
                        .foregroundColor(.black)
                }
            }
        }
    }
}


#Preview {
    BellView()
}
