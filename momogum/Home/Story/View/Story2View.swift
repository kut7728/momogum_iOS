//
//  Story2View.swift
//  momogum
//
//  Created by 김윤진 on 1/31/25.
//

import SwiftUI

struct Story2View: View {
    var userID: String
    @Binding var isTabBarHidden: Bool
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = Story2ViewModel()

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
                
                headerView()  // 상단 유저 정보 및 신고 버튼
                postContentView()  // 게시글 내용

                Spacer()
            }

            if viewModel.showPopup {
                popupView()  // 신고 완료 팝업
            }
        }
        .sheet(isPresented: $viewModel.showReportSheet) {
            ReportView(showReportSheet: $viewModel.showReportSheet, showPopup: $viewModel.showPopup)
                .presentationDetents([.fraction(3/4)])
                .presentationDragIndicator(.hidden)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - UI 컴포넌트 분리
extension Story2View {
    // 상단 헤더 (유저 정보, 신고 버튼, 닫기 버튼)
    private func headerView() -> some View {
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
                    viewModel.toggleReportSheet()
                }

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("close_s")
                    .resizable()
                    .frame(width:38, height:38)
                    .padding(.top, 22)
            }
            Spacer()
        }
    }

    // 게시글 내용
    private func postContentView() -> some View {
        ZStack {
            Rectangle()
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
    }

    // 신고 접수 팝업
    private func popupView() -> some View {
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
                viewModel.closePopup()  
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

#Preview {
    Story2View(userID: "유저아이디", isTabBarHidden: .constant(false))
}
