//
//  AppointCreateView.swift
//  momogum
//
//  Created by nelime on 1/16/25.
//

import SwiftUI

/// 약속 생성의 1단계, 친구 선택하는 뷰
struct AppointCreate1View: View {
    @Environment(NewAppointViewModel.self) var appointViewModel
    @Binding var path: [String]
    
    @State var searchText = ""
    @State var isEditing: Bool = false
    @State var buttonShowing: Bool = false
    
    private var isEditingBeforeEnd: Bool { path.dropLast().last == "create4"}

    
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return appointViewModel.friends
        } else {
            return appointViewModel.friends.filter { friend in
                return friend.nickname.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    
    var body: some View {
        @Bindable var viewModel = appointViewModel
        
        ApmBackgroundView(path: $path) {
            VStack {
                Text("식사를 함께할 친구를 선택해주세요")
                    .font(.mmg(.Body2))
                    .padding(.vertical, 30)
                
                /// 선택된 친구들 가로 스크롤 표시
                ScrollView (.horizontal) {
                    HStack {
                        ForEach(viewModel.pickedFriends, id: \.name) { friend in
                            AppointPickedFriendCellView(friend: friend)
                                .environment(viewModel)
                        }
                    }
                }
                .defaultScrollAnchor(.center)
                
                /// 검색바
                HStack {
                    if !isEditing {
                        Image("search")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.horizontal, 10)
                    }
                    
                    TextField("닉네임 or 유저 아이디로 검색", text: $searchText) { _ in
                        withAnimation {
                            isEditing = true
                        }
                    }
                        .font(.mmg(.subheader4))
                        .onSubmit {
                            withAnimation {
                                isEditing = false
                            }
                        }
                    
                    if isEditing {
                        Button {
                            searchText = ""
                        } label: {
                            Image("close_cc")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.horizontal, 10)
                        }
                    }
                }
                .modifier(ApmTextFieldViewModifier())
                .padding(.top, 20)
                
                
                /// 친구 목록
                ScrollView {
                    VStack (spacing: 20) {
                        Text("친구")
                            .font(.mmg(.subheader3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 15)
                        
                        /// 선택된 친구 상단 표시
                        ForEach(filteredFriends.filter { friend in
                            viewModel.pickedFriends.contains(where: { $0.nickname == friend.nickname })
                        }, id: \.nickname) { friend in
                            HStack {
                                AppointFriendListCellView(profile: friend)
                                Image("selected")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSelection(for: friend)
                            }
                        }
                        
                        // 전체 친구 표시
                        ForEach(filteredFriends.filter { viewModel.pickedFriends.map(\.nickname).contains($0.nickname) == false },
                                id: \.nickname) { friend in
                            HStack {
                                AppointFriendListCellView(profile: friend)
                                Image("unselected")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSelection(for: friend)
                            }
                        }
                        
//                        ForEach(filteredFriends, id: \.nickname) { friend in
//                            HStack {
//                                AppointFriendListCellView(profile: friend)
//                                Image("unselected")
//                                    .resizable()
//                                    .frame(width: 24, height: 24)
//                            }
//                            .contentShape(Rectangle())
//                            .onTapGesture {
//                                toggleSelection(for: friend)
//                            }
//                        }
                        
                    }
                    .padding(.bottom, 100)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal, 30)
            
            
            /// '다음 버튼'
            if buttonShowing {
                ApmHoveringNavButton(navLinkValue: isEditingBeforeEnd ? "" : "create2")
            }
        }
    }
    
    private func toggleSelection(for friend: Friend) {
        if appointViewModel.pickedFriends.contains(where: { $0.nickname == friend.nickname }) {
            // 이미 선택된 친구라면 리스트에서 제거
            appointViewModel.pickedFriends.removeAll { $0.nickname == friend.nickname }
            
            if (appointViewModel.pickedFriends.isEmpty) {
                withAnimation {
                    buttonShowing = false
                }
            } else {
                withAnimation {
                    buttonShowing = true
                }
            }
        } else {
            // 선택되지 않은 친구라면 리스트에 추가
            appointViewModel.pickedFriends.append(friend)
            
            withAnimation {
                buttonShowing = true
            }
        }
    }
}

#Preview {
    AppointCreate1View(path: AppointView(isTabBarHidden: .constant(true)).$path)
        .environment(NewAppointViewModel())
}
