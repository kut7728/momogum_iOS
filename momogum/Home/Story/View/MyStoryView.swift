import SwiftUI


struct MyStoryView: View {
    @Binding var isTabBarHidden: Bool
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var storyViewModel: StoryViewModel  //  기존 뷰모델 재사용
    @State private var currentIndex: Int = 0  // 현재 보고 있는 스토리 인덱스
    @State private var isImageLoading: Bool = false  // 이미지 로딩 상태 추가
    @StateObject private var viewModel = Story2ViewModel()
    
    var body: some View {
        Color(.black_5)
            .edgesIgnoringSafeArea(.all)
        
        VStack {
            storyProgressBar()
                .padding(.top, 8)

            
            headerView()  // 상단 유저 정보 및 신고 버튼
            postContentView()  // 게시글 내용

            Spacer()
        }
        .navigationBarBackButtonHidden()


        if viewModel.showPopup {
            popupView()  // 신고 완료 팝업
        }
    }
}
    extension MyStoryView {
        
        private func storyProgressBar() -> some View {
            HStack(spacing: 4) {
                ForEach(0..<storyViewModel.Mystories.count, id: \.self) { index in
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
                Circle()
                    .frame(width:64, height:64)
                    .padding(.leading, 24)
                    .padding(.top, 22)
                    .foregroundColor(Color(.black_3))

                VStack {
                    HStack {
                        let story = storyViewModel.Mystories[currentIndex]

                        Text(story.nickname)
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
                let story = storyViewModel.Mystories[currentIndex]
                Rectangle()
                    .frame(width:360, height: 534)
                    .foregroundColor(.white)
                    .padding(.top, 44)

                VStack(alignment: .leading) {
                    let url = URL(string: story.mealDiaryImageLinks)
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 328, height: 328)
                        .clipped()
                        .padding(.top, 35)
                        .padding(.leading, 17)
                    

//                    Text(story. ?? "진짜 최고로 맛있다...✨")
//                        .font(.mmg(.subheader3))
//                        .padding(.top, 32)
//                        .padding(.leading, 17)

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
                } // 탭 범위 지정
            }
    //        .background(
    //            GeometryReader { geometry in
    //                Color.clear.contentShape(Rectangle())
    //                    .gesture(
    //                        DragGesture(minimumDistance: 0)
    //                            .onEnded { gesture in
    //                                let screenWidth = geometry.size.width
    //                                let tapX = gesture.location.x
    //
    //                                if tapX < screenWidth / 2 {
    //                                    previousStory()
    //                                } else {
    //                                    nextStory()
    //                                }
    //                            }
    //                    )
    //            }
    //        )
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
        
        ///  이전 스토리로 이동하는 함수
        private func previousStory() {
            if currentIndex > 0 {
                withAnimation {

                    currentIndex -= 1
                    print(currentIndex)
                }
            }
        }

        ///  다음 스토리로 이동하는 함수
        private func nextStory() {
            if currentIndex < storyViewModel.Mystories.count - 1 {
                withAnimation {
                    currentIndex += 1
                    print(currentIndex)
                }
            }
        }
        
     
    }

    
