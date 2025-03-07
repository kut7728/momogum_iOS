//
//  SearchView.swift
//  momogum
//
//  Created by 김윤진 on 1/21/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var accountViewModel = AccountSearchViewModel()
    @StateObject private var keywordViewModel = KeywordSearchViewModel()
    @State private var selectedButton: String = "계정"
    @State private var searchQuery: String = "" // 검색어 상태 추가

    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused: Bool
    @State private var hasStartedEditing: Bool = false // 입력 여부 추가
    
    @State private var selectedUser: AccountSearchResult?
    @State private var isNavigatingToProfile = false
    
    @State private var selectedKeyword: KeywordSearchResult?
    @State private var isNavigatingToCard = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 48, height: 48)
                            .foregroundColor(.black)
                            .padding(.leading, 8)
                        
                        TextField("계정 및 키워드 검색", text: $searchQuery, onCommit: {
                            performSearch()
                        })
                        .font(.mmg(.subheader4))
                        .foregroundColor(.primary)
                        .padding(8)
                        .textInputAutocapitalization(.never)
                        .focused($isFocused)
                        .onChange(of: searchQuery) { newValue, _ in
                            hasStartedEditing = !newValue.isEmpty
                            performSearch()
                        }
                        
                        if !searchQuery.isEmpty {
                            Button(action: {
                                withAnimation {
                                    searchQuery = ""
                                    accountViewModel.clearSearch()
                                    keywordViewModel.clearSearch()
                                    hasStartedEditing = false // 검색어 삭제 시 UI 숨김
                                }
                                isFocused = false
                            }) {
                                Image("close_cc")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }
                
                // 사용자가 입력하면 UI 표시 (hasStartedEditing이 true일 때만)
                if hasStartedEditing {
                    VStack {
                        Divider()
                            .background(Color.gray)
                            .padding(.top, 30)
                        
                        HStack(spacing: 48) {
                            Button(action: {
                                selectedButton = "계정"
                                performSearch()
                            }) {
                                VStack {
                                    Text("계정")
                                        .font(.mmg(.subheader4))
                                        .fontWeight(selectedButton == "계정" ? .bold : .regular)
                                        .foregroundColor(selectedButton == "계정" ? .black : .gray)
                                        .frame(width: 140, height: 48)
                                    
                                    Rectangle()
                                        .fill(selectedButton == "계정" ? Color.black : Color.clear)
                                        .frame(width: 140, height: 2)
                                }
                            }
                            .animation(nil, value: selectedButton)
                            
                            Button(action: {
                                selectedButton = "키워드"
                                performSearch()
                            }) {
                                VStack {
                                    Text("키워드")
                                        .font(.mmg(.subheader4))
                                        .fontWeight(selectedButton == "키워드" ? .bold : .regular)
                                        .foregroundColor(selectedButton == "키워드" ? .black : .gray)
                                        .frame(width: 140, height: 48)
                                    
                                    Rectangle()
                                        .fill(selectedButton == "키워드" ? Color.black : Color.clear)
                                        .frame(width: 140, height: 2)
                                }
                            }
                            .animation(nil, value: selectedButton)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }

                Spacer()
                    .frame(height: 32)
                
                ScrollView {
                    if selectedButton == "계정" {
                        LazyVStack(spacing: 10) {
                            ForEach(accountViewModel.accountResults) { account in
                                Button(action: {
                                    selectedUser = account
                                    isNavigatingToProfile = true
                                }) {
                                    AccountCell(account: account)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(keywordViewModel.keywordResults) { keyword in
                                Button(action: {
                                    selectedKeyword = keyword
                                    isNavigatingToCard = true
                                }) {
                                    KeywordCell(keyword: keyword)
                                        .frame(width: 166, height: 241)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .transition(.opacity)
                
                Spacer()
            }
            .onTapGesture {
                isFocused = false
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 0) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                            .frame(width: 130)
                        
                        Text("검색하기")
                            .font(.mmg(.subheader3))
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationDestination(isPresented: $isNavigatingToProfile) {
                if let user = selectedUser {
                    OtherProfileView(
                        userID: user.id,
                        isFollowing: false,
                        userName: user.userName,
                        profileImageURL: user.userImageURL,
                        about: user.about,
                        followersText: {
                            if let firstFollower = user.searchFollowName?.first, user.searchFollowCount > 1 {
                                return "\(firstFollower)님 외 \(user.searchFollowCount - 1)명이 팔로우합니다."
                            } else if let firstFollower = user.searchFollowName?.first {
                                return "\(firstFollower)님이 팔로우합니다."
                            } else {
                                return nil
                            }
                        }(), hasStory: user.hasStory,
                        hasViewedStory: user.hasViewedStory
                    )
                }
            }
            .navigationDestination(isPresented: $isNavigatingToCard) {
                if let keyword = selectedKeyword {
                    OtherCardView(isTabBarHidden: .constant(true), userID: keyword.id, mealDiaryId: keyword.id)
                }
            }
        }
    }
    
    private func performSearch() {
        if selectedButton == "계정" {
            accountViewModel.searchQuery = searchQuery
            accountViewModel.searchAccounts(reset: true)
        } else {
            keywordViewModel.searchQuery = searchQuery
            keywordViewModel.searchKeywords(reset: true)
        }
    }
}


#Preview {
    SearchView()
}
