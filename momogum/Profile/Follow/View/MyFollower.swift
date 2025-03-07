//
//  MyFollower.swift
//  momogum
//
//  Created by 류한비 on 1/19/25.
//

import SwiftUI

struct MyFollower: View {
    @ObservedObject var followViewModel: FollowViewModel
    @Binding var showPopup: Bool
    @State private var showCloseButton = false
    @State private var isEditing = false // 텍스트필드 활성화 여부
    
    @Binding var profileUserID: String?
    @Binding var popupUserID: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    searchBar
                    ForEach(followViewModel.filteredFollowers, id: \.userId) { follower in
                        FollowCell(
                            followViewModel: followViewModel,
                            showPopup: $showPopup,
                            popupUserID: $popupUserID,
                            follower: follower,
                            followingUser: nil,
                            isFollowerList: true
                        )
                        .onTapGesture {
                            profileUserID = "\(follower.userId)"
                        }
                        .onAppear {
                            if follower.userId == followViewModel.filteredFollowers.last?.userId &&
                                followViewModel.filteredFollowers.count < followViewModel.allFollowers.count {
                                followViewModel.loadMoreFollowers()
                            }
                        }
                        .listRowSeparator(.hidden)
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 5)
                    }
                }
                .padding(.bottom, 10)
                .listStyle(PlainListStyle())
                .onAppear {
                    followViewModel.fetchFollowerList(userId: followViewModel.userID) { followers in
                        DispatchQueue.main.async {
                            followViewModel.allFollowers = followers
                            followViewModel.followerCount = followers.count
                            followViewModel.updateFollowingStatus()
                        }
                    }
                }
                
            }
            .navigationDestination(item: $profileUserID) { userID in
                if let intUserID = Int(userID) {
                    OtherProfileView(
                        userID: intUserID,
                        isFollowing: followViewModel.isFollowing(userID),
                        userName: "",
                        profileImageURL: nil,
                        about: "",
                        followersText: nil
                    )
                } else {
                    Text("잘못된 유저 ID입니다.") // 변환 실패 시 대비
                }
            }
        }
    }
    
    // MARK: - 검색창
    private var searchBar: some View {
        ZStack{
            HStack(alignment: .center, spacing: 0) {
                
                Spacer()
                
                //검색바
                TextField("닉네임 or 유저아이디로 검색", text: $followViewModel.search,
                          onEditingChanged: { editing in
                    isEditing = editing
                    showCloseButton = editing
                })
                .padding(.leading, isEditing ? 0 : 43)
                .padding(.horizontal, 23)
                .frame(width: 353, height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black_5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 235 / 255, green: 232 / 255, blue: 232 / 255), lineWidth: 1)
                )
                .font(.mmg(.subheader4))
                .foregroundStyle(isEditing ? Color.black_1 : Color.black_4)
                .onChange(of: followViewModel.search) {
                    showCloseButton = true
                }
                .onSubmit { // 엔터 입력 후
                    isEditing = followViewModel.search.isEmpty ? false : true
                    showCloseButton = false
                }
                
                Spacer()
                
            }
            
            // 텍스트 필드 활성화 전
            if !isEditing {
                HStack(alignment: .center, spacing: 0){
                    Image("search")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.leading, 45)
                    
                    Spacer()
                }
            }
            
            if showCloseButton {
                HStack{
                    Spacer()
                    Button{
                        followViewModel.search = ""
                        showCloseButton = false
                    }label:{
                        Image("close_black3")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 42)
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .listRowInsets(EdgeInsets())
        .padding(.bottom, 36)
    }
}
