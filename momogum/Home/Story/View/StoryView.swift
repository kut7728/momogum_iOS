//
//  StoryView.swift
//  momogum
//
//  Created by 김윤진 on 1/21/25.
//

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
    @Environment(\.presentationMode) var presentationMode // 뒤로가기 기능
    @State private var hasStory: Bool = false // 사용자 스토리를 올렸는지 여부를 저장

    var body: some View {
        if hasStory {
            // 사용자가 스토리 업로드 시 뷰 표시
            ZStack {
                Color(.black_5)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Rectangle()
                        .frame(width:352, height:6)
                        .cornerRadius(10)
                        .foregroundStyle(.black_3)
                        .padding(.top, 8)

                    HStack {
                        Circle()
                            .frame(width:64, height:64)
                            .padding(.leading, 24)
                            .padding(.top, 22)
                            .foregroundColor(Color(red: 207 / 255, green: 207 / 255, blue: 207 / 255))

                        VStack {
                            HStack {
                                Text(userID)
                                    .font(.mmg(.subheader4))
                                    .bold()
                                    .padding(.top, 22)
                                    .padding(.leading, 12)

                                Text("n분 전")
                                    .foregroundColor(.black_3)
                                    .padding(.top, 22)
                                    .padding(.leading, 12)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Text("식당이름")
                                .font(.mmg(.Caption3))
                                .foregroundColor(.black_2)
                                .padding(.leading, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button(action: {  // 이미지 클릭 시 홈으로 돌아가기
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("close_s")
                                .resizable()
                                .frame(width:38, height:38)
                                .padding(.top, 22)
                        }
                        Spacer()
                    }

                    ZStack {
                        Rectangle() // 게시글 프레임
                            .frame(width:360, height: 534)
                            .foregroundColor(.white) // 배경색을 하얀색으로 설정
                            .padding(.top, 44)

                        VStack(alignment: .leading) {
                            Image("post_image")
                                .resizable()
                                .frame(width: 328, height: 328)
                                .clipped()
                                .padding(.top, 35)
                                .padding(.leading, 17)

                            Text("진짜 최고로 맛있다...✨")
                                .font(.mmg(.subheader3))
                                .padding(.top, 32)
                                .padding(.leading, 17)

                            Spacer()
                        }
                        .frame(width: 360, height: 534, alignment: .topLeading)
                    }

                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
        } else {
            // 사용자가 스토리를 올리지 않았다면 기본 뷰 표시
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

                Button(action: {
                    hasStory = true // 사용자가 스토리를 작성하면 hasStory를 true로 변경
                }) {
                    Text("바로 밥일기 작성하기")
                        .font(.mmg(.subheader3))
                        .foregroundColor(Color(.momogumRed))
                        .padding()
                        .frame(width: 312, height: 52)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(.momogumRed), lineWidth: 2)
                        )
                }
                .padding(.top, 100)

                Spacer() // 아래쪽에 빈 공간 추가
            }
            .frame(maxWidth: .infinity) // VStack의 최대 너비를 설정하여 중앙 정렬
            .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 뒤로가기 동작
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    StoryView(userID: "유저아이디", tabIndex: .constant(0))
}
