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
                
                if let _ = homeviewModel.selectedButtonIndex {
                    foodDiaryGridView()
                }
                
                Spacer()
            }
            
            .onAppear{ //홈뷰가 나타났을떄 탭바 보이게
                isTabBarHidden = false
            }
            
            .navigationDestination(for: String.self) { story in
                if story == "내 스토리" {
                    StoryView(userID: "유저아이디", tabIndex: $tabIndex, isTabBarHidden: .constant(false))
                } else {
                    Story2View(userID: "유저아이디", isTabBarHidden: .constant(false))
                }
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
                        .padding(.trailing, 18)
                        .padding(.top, 20)
                }
            
            NavigationLink(destination: BellView().onAppear { isTabBarHidden = true }
                .onDisappear { isTabBarHidden = false }) {
                    Image(systemName: "bell")
                        .imageScale(.large)
                        .foregroundStyle(.black)
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                }
            
            if homeviewModel.unreadNotificationCount > 0 {
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
                storyItem(title: "내 스토리", hasStory: false)
                storyItem(title: "momogum._.", hasStory: true)
            }
        }
    }
    
    
    private func storyItem(title: String, hasStory: Bool) -> some View {
        VStack {
            Button(action: {
                isTabBarHidden = true
                path.append(title) // path에 추가해서 이동
            }) {
                ZStack {
                    if hasStory {
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
    
    private func foodDiaryGridView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(mealDiaryViewModel.mealDiaries) { diary in //`mealDiaries`를 반복
                    NavigationLink(destination: OtherCardView(isTabBarHidden: $isTabBarHidden)) {
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
                                
                                if homeviewModel.selectedButtonIndex == 0 { // "또 올래요:)" 만 이미지 띄우기
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
                                    
                                    Text(diary.foodCategory)
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
                                .stroke(Color.black_4, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
}


#Preview {
    HomeView(tabIndex: .constant(0), isTabBarHidden: .constant(false))
}
