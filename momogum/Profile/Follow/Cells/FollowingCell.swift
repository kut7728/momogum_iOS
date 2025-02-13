//
//  FollowingCell.swift
//  momogum
//
//  Created by 류한비 on 1/19/25.
//

import SwiftUI

struct FollowingCell: View {
    @Bindable var followViewModel: FollowViewModel
    @State private var isFollowing: Bool = false
    var userID: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0){
            // 프로필 사진
            Image("defaultProfile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 52, height: 52)
                .clipShape(Circle())
                .padding(.trailing, 16)
            
            VStack(alignment: .leading, spacing: 0){
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
            
            Button {
                isFollowing.toggle()
                if isFollowing {
                    followViewModel.follow(userID) // 즉시 반영
                } else {
                    followViewModel.delayedUnfollow(userID) // 뒤로가기 시 반영
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
            .onAppear {
                isFollowing = followViewModel.isFollowing(userID)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
