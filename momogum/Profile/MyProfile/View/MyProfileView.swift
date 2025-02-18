//
//  MyProfileView.swift
//  momogum
//
//  Created by 류한비 on 1/18/25.
//

import SwiftUI

struct MyProfileView: View {
    @State private var navigationPath = NavigationPath()
    @State private var selectedSegment = 0
    @State private var showFollowList = 0
    @State private var navigateToFollowView = false // 화면 전환 제어
    @State private var navigateToMyCardView = false
    // 팝업창 제어
    @State private var showPopup = false
    @State private var showLogoutPopup = false
    @State private var showDelPopup = false
    
    var mealDiary: ProfileMealDiary? = nil
    
    @StateObject var viewModel = ProfileViewModel(userId: 1)
    @State var followViewModel: FollowViewModel = FollowViewModel()
    
    @Binding var isTabBarHidden: Bool
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        ZStack{
            NavigationStack(path: $navigationPath){
                VStack{
                    VStack{
                        // NavigationBar
                        MyProfileNavigationBar()
                        
                        // 프로필 사진 / 유저정보
                        MyProfileUserData()
                        
                        // 팔로워 / 팔로잉 / 프로필 편집
                        MyProfileEdit()
                    }
                    
                    // 내 게시물 / 저장 게시물 SegmentedControl
                    SegmentedControl()
                    
                    // 밥일기 Card
                    MyCardList()
                }
                .toolbar(.hidden, for: .navigationBar)
                .onAppear {
                    if isTabBarHidden {
                        isTabBarHidden = false
                    }
                }
                .onAppear { // 밥일기 새로고침
                    viewModel.refreshMealDiaries()
                }
            }
            .disabled(showPopup) // 팝업이 보일 때 메인 화면 비활성화
            
            // Popup
            ShowPopup()
            
        }
    }
}
// MARK: - extension
private extension MyProfileView {
    
    // NavigationBar
    private func MyProfileNavigationBar() -> some View {
        HStack(alignment: .center) {
            Spacer()
            Spacer().frame(width: 24, height: 24)
            
            // 내 유저 아이디
            Text(viewModel.userID)
                .frame(height: 20)
                .fontWeight(.semibold)
            
            Spacer()
            
            // 설정 버튼
            Button {
                showPopup = true
            } label: {
                Image("settings")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 23)
        .padding(.bottom, 20)
    }
    
    // 프로필 사진 / 유저정보
    private func MyProfileUserData() -> some View {
        HStack(alignment: .center, spacing: 0){
            // 프로필 이미지
            if let profileImage = viewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 78, height: 78)
                    .clipShape(Circle())
                    .padding(3)
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 4)
                            .foregroundStyle(Color.black_4)
                    )
                    .padding(.trailing, 38)
            } else {
                Image("defaultProfile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 78, height: 78)
                    .clipShape(Circle())
                    .padding(3)
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 4)
                            .foregroundStyle(Color.black_4)
                    )
                    .padding(.trailing, 38)
            }
            
            // 이름 / 한 줄 소개
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    // 이름
                    Text(viewModel.userName)
                        .font(.mmg(.subheader4))
                        .padding(.bottom, 13)
                    
                    Text(viewModel.userBio)
                        .font(.mmg(.Caption2))
                        .foregroundStyle(Color.black_2)
                }
            }
            
            Spacer()
            
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.horizontal, 32)
        .padding(.bottom, 24)
    }
    
    // 팔로워 / 팔로잉 / 프로필 편집
    private func MyProfileEdit() -> some View {
        HStack(alignment: .center, spacing: 0){
            // 팔로워
            Button(action: {
                DispatchQueue.main.async {
                    showFollowList = 0
                    navigateToFollowView = true
                }
                isTabBarHidden = true
            }) {
                VStack(alignment: .center, spacing: 0){
                    Text("팔로워")
                        .font(.mmg(.subheader4))
                        .foregroundStyle(Color.black_1)
                        .padding(.bottom, 16)
                    
                    Text("\(followViewModel.followerCount.formattedFollowerCount())")
                        .font(.mmg(.subheader4))
                        .foregroundStyle(Color.black_1)
                }
            }
            .padding(.trailing, 67)
            
            // 팔로잉
            Button(action: {
                DispatchQueue.main.async {
                    showFollowList = 1
                    navigateToFollowView = true
                }
                isTabBarHidden = true
            }) {
                VStack(alignment: .center, spacing: 0){
                    Text("팔로잉")
                        .font(.mmg(.subheader4))
                        .foregroundStyle(Color.black_1)
                        .padding(.bottom, 16)
                    
                    Text("\(followViewModel.followingCount.formattedFollowerCount())")
                        .font(.mmg(.subheader4))
                        .foregroundStyle(Color.black_1)
                }
            }
            .padding(.trailing, 67)
            
            // 프로필 편집 버튼
            Button {
                DispatchQueue.main.async {
                    navigationPath.append("EditProfileView")
                    isTabBarHidden = true
                }
            }label: {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 86, height: 52)
                    .foregroundStyle(Color.black_5)
                    .overlay(
                        VStack{
                            Image("user_circle")
                                .resizable()
                                .frame(width: 27, height: 27)
                                .padding(.bottom, 3)
                            
                            
                            Text("프로필 편집")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.black_2)
                        }
                    )
                    .contentShape(Rectangle())
            }
            .navigationDestination(isPresented: $navigateToFollowView) {
                FollowView(viewModel: viewModel, followViewModel: followViewModel, selectedSegment: $showFollowList)
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "EditProfileView":
                    EditProfileView(navigationPath: $navigationPath, viewModel: viewModel)
                case "GalleryProfileView":
                    GalleryProfileView(navigationPath: $navigationPath, profileViewModel: viewModel)
                case "EditImageView":
                    EditImageView(selectedImage: viewModel.currentPreviewImage, navigationPath: $navigationPath, profileViewModel: viewModel)
                case "EditNameView":
                    EditNameView(navigationPath: $navigationPath, viewModel: viewModel)
                case "EditIDView":
                    EditIDView(navigationPath: $navigationPath, viewModel: viewModel)
                case "EditBioView":
                    EditBioView(navigationPath: $navigationPath, viewModel: viewModel)
                default:
                    EmptyView()
                }
            }
        }
        .padding(.bottom, 23)
    }
    
    // 내 게시물 / 저장 게시물 SegmentedControl
    private func SegmentedControl() -> some View {
        HStack {
            VStack(spacing: 0){
                Image(selectedSegment == 0 ? "card_red2" : "card_black4")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(selectedSegment == 0 ? Color.momogumRed : .black_4)
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedSegment = (selectedSegment == 1) ? 0 : selectedSegment
                    }
                    .padding(.bottom, 16)
                
                Rectangle()
                    .frame(width: 166, height: 2)
                    .foregroundStyle(selectedSegment == 0 ? Color.momogumRed : .black_4)
                
            }
            .padding(.trailing, 10)
            
            VStack(spacing: 0){
                Image(selectedSegment == 0 ? "bookmark_black4" : "bookmark_red2")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(selectedSegment == 0 ? Color.black_4 : .momogumRed)
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedSegment = (selectedSegment == 0) ? 1 : selectedSegment
                    }
                    .padding(.bottom, 16)
                
                Rectangle()
                    .frame(width: 166, height: 2)
                    .foregroundStyle(selectedSegment == 0 ? Color.black_4 : .momogumRed)
            }
        }
        .padding(.bottom, 41)
        .padding(.horizontal, 10)
        .navigationDestination(isPresented: $navigateToMyCardView) {
            if let mealDiary = mealDiary {
                MyCardView(isTabBarHidden: $isTabBarHidden, mealDiaryId: Int(mealDiary.mealDiaryId))
                    .onAppear { isTabBarHidden = true }
                    .onDisappear { isTabBarHidden = false }
            } else {
                Text("잘못된 접근입니다.")
            }
        }
    }
    
    // 밥일기 Card
    private func MyCardList() -> some View {
        ScrollView {
            if (selectedSegment == 0 ? viewModel.mealDiaries : viewModel.bookmarkedMealDiaries).isEmpty {
                VStack {
                    Text(selectedSegment == 0 ? "아직 기록된 밥일기가 없어요. 첫 기록을 남겨볼까요?" : "저장된 밥일기가 없습니다. 지금 저장해보세요!")
                        .font(.mmg(.Caption2))
                        .foregroundColor(Color.black_4)
                        .padding(.top, 150)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach((selectedSegment == 0 ? viewModel.mealDiaries : viewModel.bookmarkedMealDiaries).reversed(), id: \.mealDiaryId) { mealDiary in
                        NavigationLink(destination: MyCardView(isTabBarHidden: $isTabBarHidden, mealDiaryId: Int(mealDiary.mealDiaryId))
                            .onAppear { isTabBarHidden = true }
                            .onDisappear { isTabBarHidden = false }
                        ) {
                            CardPostCell(selectedSegment: $selectedSegment, mealDiary: mealDiary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }
        }
    }
    
    // Popup
    private func ShowPopup() -> some View {
        ZStack{
            if showPopup {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPopup = false // 바깥 영역 터치 시 팝업 비활성화
                    }
                
                SettingsPopupView(showPopup: $showPopup, showLogoutPopup: $showLogoutPopup, showDelPopup: $showDelPopup)
                    .padding(.bottom, UIScreen.main.bounds.height <= 812 ? 450 : 525)
                    .padding(.leading, UIScreen.main.bounds.height <= 812 ? 180 : 205)
                    .padding(.trailing, 37)
            } else if showLogoutPopup {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showLogoutPopup = false
                    }
                LogoutPopupView(showLogoutPopup: $showLogoutPopup)
            } else if showDelPopup {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showDelPopup = false
                    }
                DelAccPopupView(showDelPopup: $showDelPopup)
            }
        }
    }
}

