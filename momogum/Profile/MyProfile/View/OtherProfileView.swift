//
//  OtherProfileView.swift
//  momogum
//
//  Created by 류한비 on 2/8/25.
//

import SwiftUI

struct OtherProfileView: View {
    @Environment(\.dismiss) var dismiss
    var userID: String
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
    @State private var navigateToMyCardView = false
    
    @State var viewModel: ProfileViewModel
    @State var followViewModel: FollowViewModel = FollowViewModel()
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        ZStack{
            VStack{
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        Button{
                            dismiss()
                        }label:{
                            Image("back")
                                .resizable()
                                .frame(width: 24,height: 24)
                        }
                        
                        Spacer()
                        
                        // 유저 아이디
                        Text(userID)
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
                    
                    HStack(alignment: .center, spacing: 0) {
                        // ✅ 스토리 유무에 따른 프로필 이미지 테두리 설정
                        if let imageUrl = profileImageURL, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Image("defaultProfile")
                                    .resizable()
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 78, height: 78)
                            .clipShape(Circle())
                            .padding(3)
                            .overlay(
                                Circle()
                                    .stroke(lineWidth: 4)
                                    .foregroundStyle(
                                        hasStory
                                            ? (hasViewedStory
                                                ? LinearGradient(
                                                    gradient: Gradient(colors: [Color.black_4, Color.black_4]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                  )
                                                : LinearGradient(
                                                    gradient: Gradient(colors: [Color.Red_3, Color.momogumRed]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                  )
                                              )
                                            : LinearGradient(
                                                gradient: Gradient(colors: [Color.clear, Color.clear]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                              )
                                    )

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
                                        .foregroundStyle(
                                            hasStory
                                                ? (hasViewedStory
                                                    ? LinearGradient(
                                                        gradient: Gradient(colors: [Color.black_4, Color.black_4]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                      )
                                                    : LinearGradient(
                                                        gradient: Gradient(colors: [Color.Red_3, Color.momogumRed]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                      )
                                                  )
                                                : LinearGradient(
                                                    gradient: Gradient(colors: [Color.clear, Color.clear]),  
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                  )
                                        )

                                )
                                .padding(.trailing, 38)
                        }
                        
                        
                        
                        // 이름 / 한 줄 소개
                        VStack(alignment: .leading){
                            VStack(alignment: .leading){
                                // 이름
                                Text(userName)
                                    .font(.mmg(.subheader4))
                                    .padding(.bottom, 13)
                                
                                if let about = about, !about.isEmpty {
                                    Text(about)
                                        .font(.mmg(.Caption2))
                                        .foregroundStyle(Color.black_2)
                                }
                            }
                        }
                        
                        Spacer()
                        
                    }
                    .edgesIgnoringSafeArea(.all)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                    
                    if let followersText = followersText {
                        Text(followersText) // 실제 followersText 표시
                            .font(.mmg(.Caption2))
                            .padding(.bottom, 24)
                            .padding(.leading, 33)
                    }
                    
                    HStack(alignment: .center, spacing: 0){
                        // 팔로워
                        Button(action: {
                        }) {
                            VStack(alignment: .center, spacing: 0){
                                Text("팔로워")
                                    .font(.mmg(.subheader4))
                                    .foregroundStyle(Color.black_1)
                                    .padding(.bottom, 16)
                                
                                Text("\(followerCount?.formattedFollowerCount() ?? "0")") // followerCount 사용
                                    .font(.mmg(.subheader4))
                                    .foregroundStyle(Color.black_1)
                            }
                        }
                        .padding(.trailing, 67)
                        
                        // 팔로잉
                        Button(action: {
                        }) {
                            VStack(alignment: .center, spacing: 0){
                                Text("팔로잉")
                                    .font(.mmg(.subheader4))
                                    .foregroundStyle(Color.black_1)
                                    .padding(.bottom, 16)
                                
                                Text("\(followingCount?.formattedFollowerCount() ?? "0")") // followingCount 사용
                                    .font(.mmg(.subheader4))
                                    .foregroundStyle(Color.black_1)
                            }
                        }
                        .padding(.trailing, 67)

                        
                        // 팔로우 / 팔로잉 버튼
                        if followViewModel.isFollowing(userID) {
                            Button {
                                followViewModel.unfollow(userID)
                            } label: {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: 72, height: 28)
                                    .foregroundStyle(Color.black_6)
                                    .overlay(
                                        Text("팔로잉")
                                            .font(.mmg(.subheader4))
                                            .foregroundStyle(Color.Red_2)
                                            .padding(6)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.black_4, lineWidth: 1)
                                    )
                            }
                        } else {
                            Button {
                                followViewModel.follow(userID)
                            } label: {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: 72, height: 28)
                                    .foregroundStyle(Color.Red_2)
                                    .overlay(
                                        Text("팔로우")
                                            .font(.mmg(.subheader4))
                                            .foregroundStyle(Color.black_6)
                                            .padding(6)
                                    )
                            }
                        }
                    }
                    .padding(.bottom, 23)
                    .padding(.leading, 51)
                }
                
                
                // 내 게시물 / 저장 게시물 SegmentedControl
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
                    //                        MyCardView(isTabBarHidden: $isTabBarHidden)
                    //                            .onAppear { isTabBarHidden = true }
                    //                            .onDisappear { isTabBarHidden = false }
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        //                        ForEach(0..<30, id: \.self) { index in
                        //                            //                                NavigationLink(destination: MyCardView(isTabBarHidden: $isTabBarHidden)
                        //                            //                                    .onAppear { isTabBarHidden = true }
                        //                            //                                    .onDisappear { isTabBarHidden = false }
                        //                            //                                ) {
                        //                            CardPostCell(selectedSegment: $selectedSegment)
                        //                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .disabled(showReportDetailPopup)
            
            if showReportDetailPopup {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showReportDetailPopup = false // 바깥 영역 터치 시 팝업 비활성화
                    }
                
                ReportDetailView(showReportDetailPopup: $showReportDetailPopup)
            }
        }
        .sheet(isPresented: $showReportPopup) {
            ReportPopupView(showReportDetailPopup: $showReportDetailPopup)
                .presentationDetents([.fraction(3/4)])
                .presentationDragIndicator(.hidden)
                .presentationBackground(.clear)
        }
    }
}

//#Preview {
//    OtherProfileView(userID: "", isFollowing: false, userName: "", viewModel: ProfileViewModel(userId: 1))
//}
