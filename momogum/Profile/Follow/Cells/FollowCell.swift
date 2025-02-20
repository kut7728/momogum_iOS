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
            
            // 팔로우 / 언팔로우 버튼
            Button {
                toggleFollow(for: userId)
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
            .padding(.trailing, isFollowerList ? 25 : 30)
            
            if isFollowerList {
                // X 버튼 (팔로워 목록에서만 표시)
                Button {
                    popupUserID = "\(userId)"
                    showPopup = true
                    if let userID = AuthManager.shared.UUID, let targetUserId = Int("\(userId)") {
                        followViewModel.deleteFollower(userId: userID, followerId: targetUserId)
                    }
                } label: {
                    Image("close_s")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            
        }
        .onAppear {
            if let status = followViewModel.followingStatus["\(userId)"] {
                self.isFollowing = status
            } else {
                self.isFollowing = false // 기본값
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("FollowStatusChanged"))) { notification in
            if let userInfo = notification.userInfo,
               let changedUserID = userInfo["userID"] as? String,
               let newFollowStatus = userInfo["isFollowing"] as? Bool,
               changedUserID == "\(userId)" {
                self.isFollowing = newFollowStatus
            }
        }
    }
    
    
    private func updateFollowStatus(for userId: Int) {
        self.isFollowing = followViewModel.followingStatus["\(userId)"] ?? false
    }
    
    
    private func toggleFollow(for userId: Int) {
        guard let currentUserId = AuthManager.shared.UUID else {
            print("❌ 현재 로그인한 유저 ID를 가져올 수 없습니다.")
            return
        }
        
        // 현재 팔로우 상태를 가져오기
        let wasFollowing = isFollowing
        
        // UI 변경을 바로 하지 않고, 서버 응답 후 반영
        followViewModel.toggleFollow(userId: currentUserId, targetUserId: "\(userId)")
        
        // 서버 응답을 받으면 업데이트 (API에서 성공 여부 확인)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // API 응답 시점 반영
            if let newStatus = self.followViewModel.followingStatus["\(userId)"] {
                self.isFollowing = newStatus
            } else {
                self.isFollowing = !wasFollowing // 만약 API 응답이 없으면 원래 상태로 복원
            }
        }
    }

}
