//
//  FollowView.swift
//  momogum
//
//  Created by 류한비 on 1/19/25.
//

import SwiftUI

struct FollowView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: ProfileViewModel
    @Bindable var followViewModel: FollowViewModel
    
    @Binding var selectedSegment: Int
    @State private var showPopup = false
    @State private var showCompletedPopup = false
    @State private var profileUserID: String? // 타인 프로필 이동용
    @State private var popupUserID: String? // 팔로워 목록에서 삭제할 유저 ID
    
    var body: some View {
        ZStack{
            VStack {
                HStack(alignment: .center, spacing: 0) {
                    // back 버튼
                    Button{
                        dismiss()
                    } label: {
                        Image("back")
                            .resizable()
                            .frame(width: 20,height: 20)
                    }
                    .padding(.leading, 32)
                    
                    Spacer()
                    
                    Text("\(viewModel.userID)")
                        .font(.mmg(.subheader3))
                        .foregroundColor(.black)
                    
                    Spacer()
                    Spacer().frame(width: 20, height: 20)
                }
                .padding(.top, 82)
                .padding(.trailing, 32)
                
                HStack(alignment: .center, spacing: 0) {
                    // 팔로워 segment
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(followViewModel.followerCount.formattedFollowerCount())   팔로워")
                            .font(.mmg(.subheader4))
                            .foregroundColor(selectedSegment == 0 ? Color.black_1 : Color.black_3)
                            .onTapGesture {
                                selectedSegment = 0
                            }
                            .padding(.bottom, 15)
                        
                        // 선택 하단선
                        Rectangle()
                            .frame(width: 140, height: 2)
                            .foregroundColor(selectedSegment == 0 ? .black : .clear)
                    }
                    .padding(.trailing, 36)
                    
                    // 팔로잉 segment
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(followViewModel.followingCount.formattedFollowerCount())   팔로잉")
                            .font(.mmg(.subheader4))
                            .foregroundColor(selectedSegment == 1 ? Color.black_1 : Color.black_3)
                            .onTapGesture {
                                selectedSegment = 1
                            }
                            .padding(.bottom, 15)
                        
                        Rectangle()
                            .frame(width: 140, height: 2)
                            .foregroundColor(selectedSegment == 1 ? .black : .clear)
                    }
                }
                .padding(.bottom, 37)
                .padding(.top, 32)
                
                // 팔로워 / 팔로잉 목록
                if selectedSegment == 0 {
                    MyFollower(followViewModel: followViewModel, showPopup: $showPopup, profileUserID: $profileUserID, popupUserID: $popupUserID)
                } else if selectedSegment == 1 {
                    MyFollowing(followViewModel: followViewModel)
                }
            }
            .navigationBarBackButtonHidden()
            .edgesIgnoringSafeArea(.all)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden()
            
            if showPopup {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPopup = false
                    }
                UnfollowPopup(
                    showPopup: $showPopup, showCompletedPopup: $showCompletedPopup,
                    onRemove: {
                        if let userID = popupUserID {
                            followViewModel.removeFollower(userID)
                            popupUserID = nil // 초기화
                        }
                    }
                )
            }
            
            if showCompletedPopup {
                UnfollowCompletedPopup()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation {
                                showCompletedPopup = false
                            }
                        }
                    }
            }
            
        }
    }
}
