//
//  OtherProfileView.swift
//  momogum
//
//  Created by 류한비 on 2/8/25.
//

import SwiftUI

struct OtherProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    var userID: Int
    var isFollowing: Bool
    var userName: String //검색뷰에서 이름 받기
    var profileImageURL: String? //검색뷰에서 이미지 받기
    let about: String? // 한줄소개 넘겨받기
    var hasStory: Bool  // 스토리 링
    var hasViewedStory: Bool  // 스토리링
    var followersText: String? // 검색부에서 맞팔중인사람
    var followerCount: Int?
    var followingCount: Int?
    
    @State private var showReportPopup = false
    @State private var showReportDetailPopup = false
    @State private var selectedSegment = 0
    @State private var isTabBarHidden = true
    @State private var showFollowList = 0 // 팔로워(0) / 팔로잉(1) 전환 값
    @State private var navigateToFollowView = false
    @State private var isUserFollowing: Bool = false
    
    @State var followViewModel: FollowViewModel = FollowViewModel()
    @StateObject private var viewModel: ProfileViewModel
    
    init(
        userID: Int,
        isFollowing: Bool,
        userName: String,
        profileImageURL: String?,
        about: String?,
        followersText: String?,
        followerCount: Int? = nil,
        followingCount: Int? = nil,
        hasStory: Bool = false,
        hasViewedStory: Bool = false
    ) {
        self.userID = userID
        self.isFollowing = isFollowing
        self.userName = userName
        self.profileImageURL = profileImageURL
        self.about = about
        self.followersText = followersText
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.hasStory = hasStory
        self.hasViewedStory = hasViewedStory

        _viewModel = StateObject(wrappedValue: ProfileViewModel(userId: userID)) // 해당 유저의 프로필 로드
    }

    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    VStack(alignment: .leading){
                        
                        // NavigationBar
                        MyProfileNavigationBar()
                        
                        // 프로필 사진 / 유저정보
                        MyProfileUserData()
                        
                        // @@님이 팔로우 합니다
                        if let followersText = followersText {
                            Text(followersText) // 실제 followersText 표시
                                .font(.mmg(.Caption2))
                                .padding(.bottom, 24)
                                .padding(.leading, 33)
                        }
                        
                        // 팔로워 / 팔로잉 / 프로필 편집
                        MyProfileEdit()
                        
                    }
                    
                    
                    // 내 게시물 / 저장 게시물 SegmentedControl
                    SegmentedControl()
                    
                    // 밥일기 Card
                    MyCardList()
                    
                    
                }
                .toolbar(.hidden, for: .navigationBar)
                .toolbar(.hidden, for: .tabBar)
                .disabled(showReportDetailPopup)
                
            }
            .sheet(isPresented: $showReportPopup) {
                ReportPopupView(showReportDetailPopup: $showReportDetailPopup)
                    .presentationDetents([.fraction(3/4)])
                    .presentationDragIndicator(.hidden)
                    .presentationBackground(.clear)
            }
            .onAppear {
                // 밥일기 로드
                viewModel.fetchMealDiaries(userId: userID)
                viewModel.fetchBookmarkedMealDiaries(userId: userID)
                
                // 팔로워/팔로잉 정보 로드
                followViewModel.fetchFollowerList(userId: userID)
                followViewModel.fetchFollowingList(userId: userID)
                
                // 현재 유저의 팔로우 상태 업데이트
                DispatchQueue.main.async {
                    if let currentUserId = AuthManager.shared.UUID {
                        followViewModel.fetchFollowingList(userId: currentUserId)  // ✅ 클로저 제거

                        // ✅ 0.5초 후 최신 데이터 반영
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if let status = followViewModel.followingStatus["\(userID)"] {
                                self.isUserFollowing = status
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToFollowView) {
                FollowView(
                    userID: self.userID,
                    selectedSegment: $showFollowList,
                    viewModel: viewModel
                )
            }

            
            // Popup
            ShowPopup()
        }
    }
}

// MARK: - extension
private extension OtherProfileView {
    
    // NavigationBar
    private func MyProfileNavigationBar() -> some View {
        HStack(alignment: .center){
            
            Button{
//                dismiss()
                presentationMode.wrappedValue.dismiss()
            }label:{
                Image("back")
                    .resizable()
                    .frame(width: 24,height: 24)
            }
            
            Spacer()
            
            // 유저 아이디
            Text(viewModel.userID)
                .frame(height: 20)
                .fontWeight(.semibold)
            
            Spacer()
            
            // 신고 버튼
            Button{
                showReportPopup = true
            } label: {
                Image("exclamation")
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
        HStack(alignment: .center, spacing: 0) {
            // 프로필 이미지
            if let profileImage = viewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 78, height: 78)
                    .clipShape(Circle())
                    .padding(4)
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
                    .padding(4)
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
                    
//                    Text("\(followViewModel.followerCount.formattedFollowerCount())")
//                        .font(.mmg(.subheader4))
//                        .foregroundStyle(Color.black_1)
                    Text("0")
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
                    
//                    Text("\(followViewModel.followingCount.formattedFollowerCount())")
//                        .font(.mmg(.subheader4))
//                        .foregroundStyle(Color.black_1)
                    Text("0")
                        .font(.mmg(.subheader4))
                        .foregroundStyle(Color.black_1)
                }
            }
            .padding(.trailing, 67)
            
            // 팔로우 / 팔로잉 버튼
            Button {
                toggleFollow(for: userID)
            } label: {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 72, height: 28)
                    .foregroundStyle(isUserFollowing ? Color.black_6 : Color.Red_2)
                    .overlay(
                        Text(isUserFollowing ? "팔로잉" : "팔로우")
                            .font(.mmg(.subheader4))
                            .foregroundStyle(isUserFollowing ? Color.Red_2 : Color.black_6)
                            .padding(6)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(isUserFollowing ? Color.black_4 : Color.clear, lineWidth: 1)
                    )
            }
        }
        .padding(.bottom, 23)
        .padding(.leading, 51)
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
    }
    
    // 밥일기 Card
    private func MyCardList() -> some View {
        ScrollView {
            if (selectedSegment == 0 ? viewModel.mealDiaries : viewModel.bookmarkedMealDiaries).isEmpty != true {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach((selectedSegment == 0 ? viewModel.mealDiaries : viewModel.bookmarkedMealDiaries).reversed(), id: \.mealDiaryId) { mealDiary in
                        NavigationLink(
                            destination: OtherCardView(
                                isTabBarHidden: $isTabBarHidden,
                                userID: self.userID,
                                mealDiaryId: Int(mealDiary.mealDiaryId)
                            )
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
        ZStack {
            if showReportDetailPopup {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showReportDetailPopup = false // 바깥 영역 터치 시 팝업 비활성화
                    }
                
                ReportDetailView(showReportDetailPopup: $showReportDetailPopup)
            }
        }
    }
    
    private func toggleFollow(for userId: Int) {
        guard let currentUserId = AuthManager.shared.UUID else {
            print("❌ 현재 로그인한 유저 ID를 가져올 수 없습니다.")
            return
        }

        // 버튼 클릭 시 즉시 UI 업데이트 (API 응답 기다리지 않음)
        isUserFollowing.toggle()

        //  팔로우/언팔로우 요청
        followViewModel.toggleFollow(userId: currentUserId, targetUserId: "\(userId)")

        // API 요청 후 최신 상태를 가져와 UI 반영
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            followViewModel.fetchFollowingList(userId: currentUserId) // 클로저 제거 후 호출

            // 최신 팔로우 상태 확인하여 UI 반영
            DispatchQueue.main.async {
                if let status = followViewModel.followingStatus["\(userID)"] {
                    self.isUserFollowing = status
                }
            }
        }
    }

}
