//
//  Story2View.swift
//  momogum
//
//  Created by 김윤진 on 1/31/25.
//

import SwiftUI

struct Story2View: View {
    var userID: String
    @Environment(\.presentationMode) var presentationMode // 뒤로가기 기능
    @State private var showReportSheet = false // 신고하기 모달을 표시할 상태 변수
    
    var body: some View {
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
                            Text("유저아이디")
                                .font(.mmg(.subheader4))
                                .bold()
                                .padding(.top, 22)
                                .padding(.leading, 12)

                            Text("n분")
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
                
                    Image("exclamation")
                        .resizable()
                        .frame(width:30, height:30)
                        .padding(.top, 22)
                        .padding(.leading, 8)
                        .onTapGesture {
                            showReportSheet.toggle() // 모달 띄우기
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
        .sheet(isPresented: $showReportSheet) {
            ReportView()
                .presentationDetents([.height(560), .large])
                .presentationDragIndicator(.visible)
        }
        .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
    }
}

#Preview {
    Story2View(userID: "유저아이디")
}
