//
//  HomeView.swift
//  momogum
//
//  Created by 김윤진 on 1/21/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var tabIndex: Int
    @Binding var isTabBarHidden: Bool
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var storyViewModel : StoryViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let normalButtonColor = Color(.black_5)
    let selectedButtonColor = Color(.Red_2)

    var body: some View {
        NavigationStack (){
            VStack {
                headerView()
                Spacer().frame(height: 40)
                storyScrollView()
                Spacer().frame(height: 60)
                categoryTitle()
                categoryButtons()

                if let _ = viewModel.selectedButtonIndex {
                    foodDiaryGridView()
                }

                Spacer()
            }
            .onAppear{
                storyViewModel.fetchStory(for: AuthManager.shared.UUID ?? 1)
            }
        }
    }
}

// ✅ MARK: - UI 컴포넌트 분리
extension HomeView {
    private func headerView() -> some View {
        HStack {
            Image("LoGo")
                .resizable()
                .scaledToFit()
                .frame(width: 107, height: 37)
                .padding(.leading, 20)
                .padding(.top, 20)

            Spacer()
            
            NavigationLink(destination: SearchView().onAppear { isTabBarHidden = true }
                .onDisappear { isTabBarHidden = false }) {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .foregroundStyle(.black)
                    .padding(.trailing, 12)
                    .padding(.top, 20)
            }

            NavigationLink(destination: BellView().onAppear { isTabBarHidden = true }
                .onDisappear { isTabBarHidden = false }) {
                Image(systemName: "bell")
                    .imageScale(.large)
                    .foregroundStyle(.black)
                    .padding(.trailing, 27)
                    .padding(.top, 20)
            }

            if viewModel.unreadNotificationCount > 0 {
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
                    .offset(x: -30, y: -10)
            }
        }
        .padding(.horizontal, 16)
    }

    // 스토리 리스트
    private func storyScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                storyItem(title: "내 스토리", hasStory: false, destination: StoryView(userID: "", tabIndex: $tabIndex))
//                storyItem(title: "momogum._.", hasStory: true, destination: Story2View(userID: "", isTabBarHidden: .constant(false)))
                
                let sortedStories = Array(storyViewModel.groupedStories).sorted(by: { $0.key < $1.key })

                ForEach(sortedStories, id:\.key){ (nickname , stories) in
                    if !stories.isEmpty {

                        let StoryIDList = storyViewModel.getStoryIDs(for: nickname)
                        let firstUnviewedStory = stories.first{ !$0.viewed}
                        let storyToShow = firstUnviewedStory ?? stories.first
                        let hasUnviewedStory = stories.contains { !$0.viewed }
                        
                        if let story = storyToShow{
                            
                            StoryItemCell(
                                nickname: nickname,
                                viewed: story.viewed,
                                storyIDs: StoryIDList,
                                storyViewModel: storyViewModel,
                                destination: AnyView(Story2View(isTabBarHidden: $isTabBarHidden, nickname: nickname, storyIDList: StoryIDList)),
                                isTabBarHidden: $isTabBarHidden
                            )
                          
                            
                            // StoryItem 을 넣을 예정
                            // 전달값으로는 nickname, 반드시 story.viewed, storyViewModel, mealDiaryStoryId의 목록을 전달해야함
                            
                        }
                    }
                    
                }
            }
        }
    }
   

    
    //홈뷰에 나타나는 스토리리스트
    private func storyItem(title: String, hasStory: Bool, destination: some View) -> some View {
        VStack {
            NavigationLink(destination: destination.onAppear { isTabBarHidden = true }
                .onDisappear { isTabBarHidden = false }) {
                ZStack {
                    if hasStory {
                        // ✅ 스토리가 있는 경우 - 그라데이션 테두리 유지
                        Circle()
                            .strokeBorder(
                                LinearGradient(gradient: Gradient(colors: [
                                    Color(.Red_3),
                                    Color(.momogumRed)
                                ]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 6
                            )
                            .frame(width: 90, height: 90)
                    } else {
                        // 스토리가 없는 경우 - 기본 회색 테두리 유지
                        Circle()
                            .strokeBorder(Color.gray.opacity(0.5), lineWidth: 6)
                            .frame(width: 90, height: 90)
                    }

                    Image("pixelsImage")
                        .resizable()
                        .frame(width: 76, height: 76)
                }
            }
            Text(title)
                .bold()
                .font(.mmg(.Caption2))
        }
        .padding(.leading, 24)
    }

    


    
    private func categoryTitle() -> some View {
        HStack {
            Text("다양한 밥일기 \n둘러보기")
                .bold()
                .font(.mmg(.subheader1))
                .padding(.leading, 24)
            Spacer()
        }
    }

    private func categoryButtons() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewModel.buttonLabels.indices, id: \.self) { index in
                    Button(action: { viewModel.selectButton(index: index) }) {
                        Text(viewModel.buttonLabels[index])
                            .font(.mmg(.subheader4))
                            .padding(.horizontal, 16)
                            .frame(height: 32)
                            .background(viewModel.selectedButtonIndex == index ? selectedButtonColor : normalButtonColor)
                            .foregroundColor(viewModel.selectedButtonIndex == index ? .white : .gray)
                            .bold()
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.top, 24)
            .padding(.leading, 12)
        }
    }

    private func foodDiaryGridView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<6) { index in
                    NavigationLink(destination: OtherCardView(isTabBarHidden: $isTabBarHidden)) {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 166, height: 166)

                            ZStack {
                                Color.white
                                    .frame(width: 166, height: 75)

                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 36, height: 36)

                                    Text("식사메뉴")
                                        .font(.mmg(.Caption1))
                                        .foregroundColor(.black)

                                    Spacer()
                                }
                                .frame(width: 144, height: 36)
                            }
                        }
                        .frame(width: 166, height: 241)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}


//#Preview {
//    HomeView(tabIndex: .constant(0), isTabBarHidden: .constant(false))
//}
