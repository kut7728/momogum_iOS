//
//  Story2View.swift
//  momogum
//
//  Created by 김윤진 on 1/31/25.
//

import SwiftUI

struct Story2View: View {
    @Binding var isTabBarHidden: Bool
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var storyViewModel = StoryViewModel()
    @StateObject private var viewModel = Story2ViewModel()
    
    let nickname: String
    let storyIDList: [Int]
    @State private var currentIndex: Int = 0
    @State private var selectedStory : StoryDetailResult?
//    @Binding var path: String
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
        .onAppear {
            if let firstStoryID = storyIDList.first, let memberId = AuthManager.shared.UUID {
                storyViewModel.fetchStoryDetail(for: memberId, storyId: firstStoryID)
            } else {
                print("Error: storyIDList is empty or memberId is nil")
            }
        }
        .onAppear(){
            print(nickname)
            print("storyIDList: \(storyIDList)")
            StoryViewModel().fetchStoryDetail(for: AuthManager.shared.UUID ?? 1, storyId: storyIDList[currentIndex])
            print("currentIndex: \(storyIDList[currentIndex])")
            
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
                    Text(storyViewModel.selectedStory?.name ?? "유저아이디")
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

                Text(storyViewModel.selectedStory?.location ?? "식당이름")
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
                if let imageUrl = storyViewModel.selectedStory?.mealDiaryImageLinks.first, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 328, height: 328)
                    .clipped()
                    .padding(.top, 35)
                    .padding(.leading, 17)
                }

                Text(storyViewModel.selectedStory?.description ?? "진짜 최고로 맛있다...✨")
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
            Text("신고가 접수되었습니다.")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.black_2)
                .padding(.top, 31)

            Text("검토는 최대 24시간 소요됩니다.")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.black_2)

            Divider()
                .frame(width: 300, height: 1)
                .foregroundStyle(Color.black_4)
                .padding(.top, 28)

            Button(action: {
                viewModel.closePopup()  
            }) {
                Text("확인")
                    .font(.mmg(.subheader4))
                    .foregroundColor(.Blue_1)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .background(Color.white)
            }
        }
        .frame(width: 319, height: 185)
        .background(Color.black_6)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black_5, lineWidth: 1)
        )
        .onDisappear { // 뒤로 갈 때 탭 바 다시 보이게
            isTabBarHidden = false
        }
    }
    
    
    
    private func previousStory() {
        if currentIndex > 0 {
            currentIndex -= 1
            storyViewModel.fetchStoryDetail(for: AuthManager.shared.UUID ?? 1, storyId: storyIDList[currentIndex-1])
        }
    }

    private func nextStory() {
        if currentIndex < storyIDList.count - 1 {
            currentIndex += 1
            storyViewModel.fetchStoryDetail(for: AuthManager.shared.UUID ?? 1, storyId: storyIDList[currentIndex+1])
        }
    }
}

//#Preview {
//    Story2View(userID: "유저아이디", isTabBarHidden: .constant(false))
//}
