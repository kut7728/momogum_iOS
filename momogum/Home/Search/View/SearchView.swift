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
    @State private var isEditing: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused: Bool // 키보드 포커스 상태 추가

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack {
            VStack {
                // 검색 필드
                HStack {
                    if !isEditing {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 48, height: 48)
                            .foregroundColor(.black)
                            .padding(.leading, 8)
                    }
                    
                    TextField(
                        "계정 및 키워드 검색",
                        text: selectedButton == "계정" ? $accountViewModel.searchQuery : $keywordViewModel.searchQuery,
                        onEditingChanged: { editing in
                            withAnimation {
                                isEditing = editing
                            }
                        },
                        onCommit: {
                            isFocused = false // 엔터 입력 시 키보드 숨기기
                            if selectedButton == "계정" {
                                accountViewModel.searchAccounts(reset: true)
                            } else {
                                keywordViewModel.searchKeywords(reset: true)
                            }
                        }
                    )
                    .font(.mmg(.subheader4))
                    .foregroundColor(.primary)
                    .padding(8)
                    .textInputAutocapitalization(.never)
                    .focused($isFocused) // 키보드 포커스 적용
                    
                    if isEditing {
                        Button(action: {
                            withAnimation {
                                accountViewModel.clearSearch()
                                keywordViewModel.clearSearch()
                                isEditing = false
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

                if isEditing {
                    VStack {
                        Divider()
                            .background(Color.gray)
                            .padding(.top, 20)

                        // 계정 / 키워드 버튼
                        HStack(spacing: 48) {
                            Button(action: {
                                selectedButton = "계정"
                                accountViewModel.clearSearch()
                            }) {
                                VStack {
                                    Text("계정")
                                        .font(.mmg(.subheader4))
                                        .fontWeight(selectedButton == "계정" ? .bold : .regular)
                                        .foregroundColor(selectedButton == "계정" ? .black : .gray)
                                        .frame(width: 140, height: 48)
                                    
                                    Rectangle()
                                        .fill(selectedButton == "계정" ? Color.black : Color.gray)
                                        .frame(width: 140, height: 2)
                                        .padding(.top, 2)
                                }
                            }

                            Button(action: {
                                selectedButton = "키워드"
                                keywordViewModel.clearSearch()
                                keywordViewModel.searchKeywords(reset: true)
                            }) {
                                VStack {
                                    Text("키워드")
                                        .font(.mmg(.subheader4))
                                        .fontWeight(selectedButton == "키워드" ? .bold : .regular)
                                        .foregroundColor(selectedButton == "키워드" ? .black : .gray)
                                        .frame(width: 140, height: 48)
                                    
                                    Rectangle()
                                        .fill(selectedButton == "키워드" ? Color.black : Color.gray)
                                        .frame(width: 140, height: 2)
                                        .padding(.top, 2)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    }
                    .transition(.opacity)
                }
            }
            .onTapGesture {
                isFocused = false // 다른 곳을 터치하면 키보드 숨기기
            }

            Spacer()
        }
        .onAppear {
            isFocused = false // 초기에는 키보드를 숨긴 상태로 설정
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
                    
                    Text("검색하기") // 기존 텍스트 유지
                        .font(.mmg(.subheader3))
                        .foregroundColor(.black)
                }
            }
        }
    }

    // 키보드를 숨기는 함수
    private func hideKeyboard() {
        isFocused = false
    }
}

#Preview {
    SearchView()
}
