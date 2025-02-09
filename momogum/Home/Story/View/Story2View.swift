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
    @State private var showReportSheet = false // 신고 모달 상태
    @State private var showPopup = false // 팝업 표시 상태

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
                        .foregroundColor(Color(.black_3))
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
                            showReportSheet.toggle() //모달
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
                        .foregroundColor(.white)
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

            // 팝업 화면 중앙표시
            if showPopup {
                VStack {
                    Text("신고가 접수되었습니다.\n검토는 최대 24시간 소요됩니다.")
                        .font(.mmg(.Body3))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)

                    Rectangle()
                        .frame(width: 300, height: 1)
                        .foregroundColor(.gray)
                        .padding(.top, 20)

                    Button(action: {
                        showPopup = false
                    }) {
                        Text("확인")
                            .font(.mmg(.subheader4))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .background(Color.white)
                    }
                }
                .frame(width: 319, height: 185)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
        .sheet(isPresented: $showReportSheet) {
            ReportView(showReportSheet: $showReportSheet, showPopup: $showPopup)
                .presentationDetents([.fraction(3/4)])
                .presentationDragIndicator(.hidden)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Story2View(userID: "유저아이디")
}
