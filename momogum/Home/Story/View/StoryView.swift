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
    @Environment(\.dismiss) private var dismiss // iOS 15+에서 권장하는 뒤로가기 기능

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
                
                NavigationLink(destination: GalleryPickerView(tabIndex: $tabIndex, isTabBarHidden: .constant(false))) {
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
                // 기본 백 버튼을 없애고, 커스텀 쉐브론 버튼을 추가
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss() // 뒤로가기 동작
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .imageScale(.large) // 아이콘 크기 조정
                    }
                }
                
                // 자동 생성되는 네비게이션 타이틀 제거
                ToolbarItem(placement: .principal) {
                    Text("")
                        .frame(height: 0) // 높이 0으로 설정하여 완전히 숨김
                }
            }
        }
    }
}

#Preview {
    StoryView(userID: "유저아이디", tabIndex: .constant(0))
}
