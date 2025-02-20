import SwiftUI

struct Story2View: View {
    @Binding var isTabBarHidden: Bool
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = Story2ViewModel()
    @StateObject private var storyViewModel = StoryViewModel()

    let nickname: String
    let storyIDList: [Int]
    @State private var currentIndex: Int = 0
    let profileImageLink: String

    var body: some View {
        ZStack {
            Color(.black_5)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                storyProgressBar()
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
            fetchCurrentStory()
        }
        .onChange(of: currentIndex) { _ in
            fetchCurrentStory()
        }
        .onAppear {
            print(nickname)
            print("storyIDList: \(storyIDList)")
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
    
    private func fetchCurrentStory() {
        let storyId = storyIDList[currentIndex]
        print("📌 Fetching story for ID: \(storyId)")
        storyViewModel.fetchStoryDetail(for: AuthManager.shared.UUID ?? 1, storyId: storyId)
    }

    private func storyProgressBar() -> some View {
        HStack(spacing: 4) {
            ForEach(0..<storyIDList.count, id: \.self) { index in
                Rectangle()
                    .fill(index <= currentIndex ? Color.red : Color.gray.opacity(0.3))
                    .frame(height: 6)
                    .cornerRadius(10)
                    .animation(.easeInOut, value: currentIndex)
            }
        }
        .frame(width: 352)
    }

    private func headerView() -> some View {
        HStack {
            AsyncImage(url: URL(string: profileImageLink)) { image in
                                    image.resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 64, height: 64)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.black_4, lineWidth: 1)
                                )
                                .padding(.leading, 24)
                                .padding(.top, 22)


            VStack {
                HStack {
                    Text(nickname)
                        .font(.mmg(.subheader4))
                        .bold()
                        .padding(.top, 22)
                        .padding(.leading, 12)
                    
                    if let createdAt = storyViewModel.selectedStory?.createdAt,  // Optional 안전하게 언랩핑
                    let date = Date.fromStringWithKST(createdAt) {
                        Text("\(date.relativeDateString())")
                            .foregroundColor(.black_3)
                            .padding(.top, 22)
                            .padding(.leading, 12)
                    } else {
                        Text("날짜 변환 실패")
                    }
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
                .frame(width: 30, height: 30)
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
                    .frame(width: 38, height: 38)
                    .padding(.top, 22)
            }
            Spacer()
        }
    }

    private func postContentView() -> some View {
        ZStack {
            Rectangle()
                .frame(width: 360, height: 534)
                .foregroundColor(.white)
                .padding(.top, 44)

            VStack(alignment: .leading) {
                if let imageUrl = storyViewModel.selectedStory?.mealDiaryImageLinks.first,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
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
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Color.clear
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width / 2)
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    previousStory()
                                }
                        )
                    Color.clear
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width / 2)
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    nextStory()
                                }
                        )
                }
            }
        }
    }

    private func popupView() -> some View {
        VStack {
            Text("신고가 접수되었습니다.")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.black_2)
                .padding(.top, 31)

            Text("검토는 최대 24시간 소요됩니다.")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.black_2)

            Divider()
                .frame(width: 300, height: 1)
                .foregroundColor(Color.black_4)
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
        .onDisappear {
            isTabBarHidden = false
        }
    }
    
    private func previousStory() {
        if currentIndex > 0 {
            withAnimation {
                currentIndex -= 1
            }
        }
    }

    private func nextStory() {
        if currentIndex < storyIDList.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        }
    }
}
