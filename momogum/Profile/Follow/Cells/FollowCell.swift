//
//  FollowCell.swift
//  momogum
//
//  Created by 류한비 on 2/20/25.
//

import SwiftUI

struct FollowCell: View {
    @ObservedObject var followViewModel: FollowViewModel
    @Binding var showPopup: Bool
    @Binding var popupUserID: String?
    
    var follower: Follower? // 팔로워 데이터
    var followingUser: FollowingUser? // 팔로잉 데이터
    var isFollowerList: Bool
    
    @State private var isFollowing: Bool = false
    
    var body: some View {
        let userId = follower?.userId ?? followingUser?.userId ?? 0
        let nickname = follower?.nickname ?? followingUser?.nickname ?? "알 수 없음"
        let name = follower?.name ?? followingUser?.name ?? ""
        let profileImage = follower?.profileImage ?? followingUser?.profileImage ?? ""
        
        HStack(alignment: .center, spacing: 0) {
            // 프로필 이미지 로드
            AsyncImage(url: URL(string: profileImage)) { image in
                image.resizable()
            } placeholder: {
                Image("defaultProfile")
                    .resizable()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: 52, height: 52)
            .clipShape(Circle())
            .padding(.trailing, 16)
            
            VStack(alignment: .leading, spacing: 0) {
                // 닉네임
                Text(nickname)
                    .font(.mmg(.subheader4))
                    .foregroundStyle(Color.black_1)
                    .padding(.bottom, 4)
                
                // 유저 이름
                Text(name)
                    .font(.mmg(.Caption3))
                    .foregroundStyle(Color.black_1)
            }
            
            Spacer()
            
            // 팔로워 목록일 때 (X 버튼 + 팔로우/언팔로우 버튼)
            if isFollowerList {
                
                // 팔로우 / 언팔로우 버튼
                Button {
                    isFollowing.toggle()
                    if isFollowing {
                        followViewModel.follow("\(userId)")
                    } else {
                        followViewModel.delayedUnfollow("\(userId)")
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 72, height: 28)
                        .foregroundStyle(isFollowing ? Color.black_6 : Color.Red_2)
                        .overlay(
                            Text(isFollowing ? "팔로잉" : "팔로우")
                                .font(.mmg(.subheader4))
                                .foregroundStyle(isFollowing ? Color.Red_2 : Color.black_6)
                                .padding(6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(isFollowing ? Color.black_4 : Color.clear, lineWidth: 1)
                        )
                }
                .padding(.trailing, 25)
                
                // X 버튼 (팔로워 목록에서만 표시)
                Button {
                    popupUserID = "\(userId)"
                    showPopup = true
                } label: {
                    Image("close_s")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            
            // 팔로잉 목록일 때 (팔로우/언팔로우 버튼만 표시)
            else {
                Button {
                    isFollowing.toggle()
                    if isFollowing {
                        followViewModel.follow("\(userId)")
                    } else {
                        followViewModel.delayedUnfollow("\(userId)")
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 72, height: 28)
                        .foregroundStyle(isFollowing ? Color.black_6 : Color.Red_2)
                        .overlay(
                            Text(isFollowing ? "팔로잉" : "팔로우")
                                .font(.mmg(.subheader4))
                                .foregroundStyle(isFollowing ? Color.Red_2 : Color.black_6)
                                .padding(6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(isFollowing ? Color.black_4 : Color.clear, lineWidth: 1)
                        )
                }
                .padding(.trailing, 30)
            }
        }
        .onAppear {
            if isFollowerList {
                // 팔로워 목록에서는 followViewModel.isFollowing() 값을 기반으로 설정
                isFollowing = followViewModel.isFollowing("\(userId)")
            } else {
                // 팔로잉 목록에서는 기본적으로 '팔로잉' 상태
                isFollowing = true
            }
        }

    }
}
