//
//  FollowerCell.swift
//  momogum
//
//  Created by 류한비 on 1/19/25.
//

import SwiftUI

struct FollowerCell: View {
    @Bindable var followViewModel: FollowViewModel
    @Binding var showPopup: Bool
    @Binding var popupUserID: String?
    var userID: String
    var onRemove: () -> Void
    
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
                .padding(.trailing, 25)
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
                .padding(.trailing, 25)
            }
            
            // X 버튼
            Button {
//                selectedUserID = userID // 선택된 유저 ID 저장
                popupUserID = userID
                showPopup = true
            } label: {
                Image("close_s")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
