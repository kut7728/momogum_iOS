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
    var userID: String
    var isFollowerList: Bool // 팔로워 목록인지 여부
    var onRemove: (() -> Void)? // 팔로워 목록에서 삭제할 때 실행
    
    @State private var isFollowing: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // 프로필 사진
            Image("defaultProfile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 52, height: 52)
                .clipShape(Circle())
                .padding(.trailing, 16)
            
            VStack(alignment: .leading, spacing: 0) {
                // 유저 아이디
                Text("\(userID)")
                    .font(.mmg(.subheader4))
                    .foregroundStyle(Color.black_1)
                    .padding(.bottom, 4)
                
                // 유저이름
                Text("이름")
                    .font(.mmg(.Caption3))
                    .foregroundStyle(Color.black_1)
            }
            
            Spacer()
            
            // 팔로우 / 언팔로우 버튼
            Button {
                guard let currentUserId = AuthManager.shared.UUID else { return }
                isFollowing.toggle()
                followViewModel.toggleFollow(userId: currentUserId, targetUserId: userID)
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
            .onAppear {
                isFollowing = followViewModel.followingStatus[userID] ?? false
                NotificationCenter.default.addObserver(forName: Notification.Name("FollowStatusChanged"), object: nil, queue: .main) { notification in
                    if let userInfo = notification.userInfo,
                       let changedUserID = userInfo["userID"] as? String,
                       let status = userInfo["isFollowing"] as? Bool,
                       changedUserID == userID {
                        isFollowing = status
                    }
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: Notification.Name("FollowStatusChanged"), object: nil)
            }
            
            
            // X 버튼 (팔로워 목록일 때만 표시)
            if isFollowerList {
                Button {
                    popupUserID = userID
                    showPopup = true
                } label: {
                    Image("close_s")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
