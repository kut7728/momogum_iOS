//
//  StoryView.swift
//  momogum
//
//  Created by 김윤진 on 1/21/25.
//

import SwiftUI

struct StoryView: View {
    var userID: String
    @Binding var tabIndex: Int
    @StateObject private var viewModel = StoryViewModel()  // 뷰 모델 연결
    @Environment(\.dismiss) private var dismiss
//    @Binding var isTabBarHidden: Bool
    @State private var isGalleryPresented = false  // 상태 변수 추가

    var body: some View {
        NavigationStack {
            VStack {
                Text("오늘의 한 끼는 어땠나요? 🍽️")
                    .font(.mmg(.Header3))
                    .bold()
                    .padding(.top, 170)
                
                Text("당신의 한 끼를 기록하고, 공유해주세요 :)")
                    .font(.mmg(.Body2))
                    .padding(.top, 1)
                    .padding(.bottom, 92)
                
                reactionIcons()
                
                Button(action: {
                    dismiss()
                    tabIndex = 1

                }) {
                    Text("바로 밥일기 작성하기")
                        .font(.mmg(.subheader3))
                        .foregroundColor(Color(red: 224/255, green: 90/255, blue: 85/255))
                        .padding()
                        .frame(width: 312, height: 52)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(red: 224/255, green: 90/255, blue: 85/255), lineWidth: 2)
                        )
                }
                .padding(.top, 100)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨김
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .imageScale(.large)
                    }
                }

            }
        }
    }
}

// MARK: - UI 컴포넌트 분리
extension StoryView {
    // 이모지 아이콘
    private func reactionIcons() -> some View {
        HStack {
            Image("no")
                .resizable()
                .scaledToFit()
                .frame(width: 95, height: 95)
            
            Image("notbad")
                .resizable()
                .scaledToFit()
                .frame(width: 95, height: 95)
            
            Image("yes")
                .resizable()
                .scaledToFit()
                .frame(width: 95, height: 95)
        }
    }
}

#Preview {
    StoryView(userID: "유저아이디", tabIndex: .constant(0))
}
