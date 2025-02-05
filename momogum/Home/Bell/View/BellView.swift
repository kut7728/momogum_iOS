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

    var body: some View {
        VStack {
            // 읽지 않은 알림 섹션
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("읽지않음")
                        .font(.mmg(.subheader4))
                        .foregroundColor(.black)
                        .padding(.leading, 26)
                    
                    // 읽지 않은 알림이 있으면 배지 표시
                    if unreadCount > 0 {
                        ZStack {
                            Circle()
                                .fill(.Red_2)
                                .frame(width: 6, height: 6)
                            
                        }
                        .offset(x: 0, y: -10) // 텍스트의 오른쪽 상단에 배치
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 27)
                
                // 읽지 않은 알림 셀 리스트
                ForEach(0..<unreadCount, id: \.self) { _ in
                    NotReadCell(title: "새 댓글", message: "당신의 게시글에 새로운 댓글이 달렸습니다.", time: "5분 전")
                }
            }
            .padding(.bottom, 52)
            
            // 읽은 알림 섹션
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("최근30일")
                        .font(.mmg(.subheader4))
                        .foregroundColor(.black_2)
                        .padding(.leading, 26)
                    Spacer()
                }
                .padding(.bottom, 27)
                
                // 읽은 알림 셀 리스트
                ForEach(0..<3, id: \.self) { _ in
                    ReadCell(title: "게시글 좋아요", message: "당신의 게시글이 좋아요를 받았습니다.", time: "2일 전")
                }
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
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

#Preview {
    BellView()
}
