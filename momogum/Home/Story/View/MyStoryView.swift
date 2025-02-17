import SwiftUI


struct MyStoryView: View {
    @Binding var isTabBarHidden: Bool
    @ObservedObject var storyViewModel: StoryViewModel  //  기존 뷰모델 재사용
    @State private var currentIndex: Int = 0  // 현재 보고 있는 스토리 인덱스
    @State private var isImageLoading: Bool = false  // 이미지 로딩 상태 추가
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if storyViewModel.Mystories.isEmpty {
                    Text("아직 스토리가 없어요!")
                        .font(.title)
                        .bold()
                        .padding(.top, 20)
                        .padding(.leading, 17)
                } else {
                    let story = storyViewModel.Mystories[currentIndex]

                    // 닉네임과 프로필 이미지 함께 표시
                    HStack {
                        AsyncImage(url: URL(string: story.profileImageLink)) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.gray)
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                        Text(story.nickname)
                            .font(.title)
                            .bold()
                    }
                    .padding(.top, 20)
                    .padding(.leading, 17)

                    // ✅ 이미지 로딩 중이면 ProgressView 표시
                    if isImageLoading {
                        ProgressView()
                            .frame(width: 328, height: 328)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.top, 35)
                            .padding(.leading, 17)
                    } else if let imageUrl = URL(string: story.mealDiaryImageLinks) {
                        AsyncImage(url: imageUrl) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 328, height: 328)
                        .clipped()
                        .cornerRadius(10)
                        .padding(.top, 35)
                        .padding(.leading, 17)
                    }

                    // ✅ 설명 유지
//                    Text(story.about ?? "스토리 설명이 없습니다.")
//                        .font(.mmg(.subheader3))
//                        .padding(.top, 32)
//                        .padding(.leading, 17)

                    Spacer()
                }
            }
            .frame(width: 360, height: 534, alignment: .topLeading)

            // ✅ 화면을 탭하면 다음/이전 스토리 전환
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Color.clear
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width / 2)
                        .gesture(
                            TapGesture()
                                .onEnded { previousStory() }
                        )

                    Color.clear
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width / 2)
                        .gesture(
                            TapGesture()
                                .onEnded { nextStory() }
                        )
                }
            }
        }
        .onAppear {
            isTabBarHidden = true
            storyViewModel.fetchMyStory(for: AuthManager.shared.UUID ?? 1 )
        }
        .onDisappear {
            isTabBarHidden = false
        }
    }


    /// ✅ 이전 스토리로 이동하는 함수
    private func previousStory() {
        if currentIndex > 0 {
            withAnimation {
                currentIndex -= 1
            }
        }
    }

    /// ✅ 다음 스토리로 이동하는 함수
    private func nextStory() {
        if currentIndex < storyViewModel.Mystories.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        }
    }
}
