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
    @StateObject private var homeviewModel = HomeViewModel()
    @StateObject private var mealDiaryViewModel = MealDiaryViewModel()
    @State private var path = NavigationPath() // 네비게이션 경로 추가
    @StateObject var storyViewModel = StoryViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let normalButtonColor = Color(.black_5)
    let selectedButtonColor = Color(.Red_2)
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                headerView()
                Spacer().frame(height: 40)
                storyScrollView()
                Spacer().frame(height: 60)
                categoryTitle()
                categoryButtons()
                foodDiaryGridView()
                
//                if let _ = homeviewModel.selectedButtonIndex {
//                    
//                }
                
                Spacer()
            }
            
            .onAppear{ //홈뷰가 나타났을떄 탭바 보이게
                isTabBarHidden = false
            }
            
            .navigationDestination(for: String.self) { story in
                if story == "내 스토리" {
                    StoryView(userID: "유저아이디", tabIndex: $tabIndex, isTabBarHidden: .constant(false))
                } else {
                    //                    Story2View(userID: "유저아이디", isTabBarHidden: .constant(false))
                }
            }
            .onAppear{
                storyViewModel.fetchStory(for: AuthManager.shared.UUID ?? 1)
                storyViewModel.fetchMyStory(for: AuthManager.shared.UUID ?? 1)
                
            }
            .onDisappear {
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
            ) {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .foregroundStyle(.black)
                    .padding(.trailing, 18)
                    .padding(.top, 20)
            }
            
            NavigationLink(destination: BellView().onAppear { isTabBarHidden = true }
                .onDisappear { isTabBarHidden = false }) {
                    Image(systemName: "bell")
                        .imageScale(.large)
                        .foregroundStyle(.black)
                        .padding(.trailing, 10)
                        .padding(.top, 20)
                }
            
            if homeviewModel.unreadNotificationCount > 0 {
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
                    .offset(x: -20, y: -10)
            }
        }
        .padding(.horizontal, 16)
    }
    
    // 스토리 리스트
    private func storyScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                
                if let firstStory = storyViewModel.Mystories.first {
                    
                    let sortedStoryIDList = storyViewModel.MyStoryIDList()
                    storyItem(
                        title: firstStory.nickname,
                        viewed: firstStory.viewed,
                        nickname: firstStory.nickname,
                        profileImage: firstStory.profileImageLink,
                        storyIDList: sortedStoryIDList // 전체 스토리 ID 리스트 전달
                    )
                }else{
                    
                }
                
                let sortedStories = storyViewModel.sortedGroupedStories //정렬이 끝난 스토리값
                
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
                                destination: AnyView(Story2View(isTabBarHidden: $isTabBarHidden, nickname: nickname, storyIDList: StoryIDList,profileImageLink: story.profileImageLink)),
                                hasUnViewedStory: hasUnviewedStory,
                                profileImageLink: story.profileImageLink,
                                isTabBarHidden: $isTabBarHidden
                            )
                            .onAppear(){
                                print("스토리디테일:\(storyViewModel.selectedStory)")
                                print(story.viewed)
                                print("StoryIDs : \(StoryIDList)")
                                print(firstUnviewedStory)
                                print("📌 \(nickname) - \(stories.map { $0.viewed })")
                            }
                            
                            
                            
                            // StoryItem 을 넣을 예정
                            // 전달값으로는 nickname, 반드시 story.viewed, storyViewModel, mealDiaryStoryId의 목록을 전달해야함
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    
    
    //홈뷰에 나타나는 스토리리스트
    private func storyItem(title: String,
                           viewed: Bool,
                           nickname: String,
                           profileImage: String,
                           storyIDList: [Int]) -> some View {
        VStack {
            NavigationLink(
                destination: MyStoryView(
                    isTabBarHidden: $isTabBarHidden,
                    nickname: nickname,
                    storyIDList: storyIDList,
                    profileImageLink: profileImage
                )
                .onAppear { isTabBarHidden = true }
            ) {
                ZStack {
                    if viewed {
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
                        Circle()
                            .strokeBorder(Color.black_4, lineWidth: 6)
                            .frame(width: 90, height: 90)
                    }
                    
                    if let url = URL(string: profileImage) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            Image("pixelsImage")
                                .resizable()
                        }
                        .frame(width: 76, height: 76)
                        .clipShape(Circle())
                    } else {
                        Image("pixelsImage")
                            .resizable()
                            .frame(width: 76, height: 76)
                            .clipShape(Circle())
                    }
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
                ForEach(homeviewModel.buttonLabels.indices, id: \.self) { index in
                    Button(action: { homeviewModel.selectButton(index: index, mealDiaryViewModel: mealDiaryViewModel) }) {
                        Text(homeviewModel.buttonLabels[index])
                            .font(.mmg(.subheader4))
                            .padding(.horizontal, 16)
                            .frame(height: 32)
                            .background(homeviewModel.selectedButtonIndex == index ? selectedButtonColor : normalButtonColor)
                            .foregroundColor(homeviewModel.selectedButtonIndex == index ? .white : .gray)
                            .bold()
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.top, 24)
            .padding(.leading, 12)
        }
    }
    
    // ✅ 변경된 foodDiaryGridView()
    private func foodDiaryGridView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(mealDiaryViewModel.mealDiaries, id: \.id) { diary in
                    FoodDiaryGridItemView(diary: diary, isTabBarHidden: $isTabBarHidden, homeviewModel: homeviewModel)
                }
                
                Spacer()
                    .frame(height: 80)
                
            }
            .padding(.top, 15)
            .padding(.horizontal, 16)

        }
        .refreshable {
            storyViewModel.fetchStory(for: AuthManager.shared.UUID ?? 1)
            storyViewModel.fetchMyStory(for: AuthManager.shared.UUID ?? 1)
        }
    }
    
    // 그리드 따로 빼기
    private struct FoodDiaryGridItemView: View {
        let diary: MealDiary
        @Binding var isTabBarHidden: Bool
        let homeviewModel: HomeViewModel // `let`으로 선언하여 값이 불변하도록 유지
        
        var body: some View {
            NavigationLink(destination: OtherCardView(isTabBarHidden: $isTabBarHidden, mealDiaryId: diary.id)) {
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        AsyncImage(url: URL(string: diary.foodImageURLs.first ?? "")) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            Image("post_image")
                                .resizable()
                                .frame(width: 166, height: 166)
                        }
                        .frame(width: 166, height: 166)
                        
                        if homeviewModel.selectedButtonIndex == 0 {
                            Image("good_fill")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .padding(.top, 123)
                                .padding(.leading, 122)
                        }
                    }
                    
                    ZStack {
                        Color.white
                            .frame(width: 166, height: 75)
                        
                        HStack(spacing: 8) {
                            AsyncImage(url: URL(string: diary.userImageURL)) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Image("pixelsImage")
                                    .resizable()
                            }
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                            
                            Text(diary.keyWord)
                                .font(.mmg(.Caption1))
                                .foregroundColor(.black)
                                .lineLimit(1) // 메뉴이름 길어지면 ...처리
                                .truncationMode(.tail)
                            
                            Spacer()
                        }
                        .frame(width: 144, height: 36)
                    }
                }
                .frame(width: 166, height: 241)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black_4, lineWidth: 1)
                )
            }
        }
    }
}



#Preview {
    HomeView(tabIndex: .constant(0), isTabBarHidden: .constant(false), storyViewModel: StoryViewModel())
}
