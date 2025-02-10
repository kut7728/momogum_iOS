//
//  SearchView.swift
//  momogum
//
//  Created by 김윤진 on 1/21/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var accountViewModel = AccountSearchViewModel() // 계정 검색 뷰모델
    @StateObject private var keywordViewModel = KeywordSearchViewModel() // 키워드 검색 뷰모델
    @State private var selectedButton: String = "계정" // 🔹 직접 선언하여 사용
    @State private var isEditing: Bool = false // 텍스트 필드 편집 상태
    @Environment(\.presentationMode) var presentationMode // 뒤로가기 기능

    var body: some View {
        VStack {
            VStack {
                HStack {
                    if !isEditing {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 48, height: 48)
                            .foregroundColor(.black)
                            .padding(.leading, 8)
                    }
                    
                    TextField("계정 및 키워드 검색", text: selectedButton == "계정" ? $accountViewModel.searchQuery : $keywordViewModel.searchQuery, onEditingChanged: { editing in
                        withAnimation {
                            isEditing = editing
                        }
                    })
                    .font(.mmg(.subheader4))
                    .foregroundColor(.primary)
                    .padding(8)
                    .textInputAutocapitalization(.never)
                    
                    if isEditing {
                        Button(action: {
                            withAnimation {
                                accountViewModel.clearSearch() // 🔹 오류 해결됨!
                                keywordViewModel.clearSearch() // 🔹 오류 해결됨!
                                isEditing = false
                            }
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                        
                        HStack(spacing: 48) {
                            Button(action: {
                                selectedButton = "계정" // 🔹 버튼 선택 시 변경
                                accountViewModel.searchQuery = ""
                                keywordViewModel.searchQuery = ""
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
                                selectedButton = "키워드" // 🔹 버튼 선택 시 변경
                                accountViewModel.searchQuery = ""
                                keywordViewModel.searchQuery = ""
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
                        
                        // 🔹 검색 결과 표시 (계정)
                        if selectedButton == "계정" {
                            VStack(spacing: 16) {
                                if accountViewModel.isLoading {
                                    ProgressView()
                                } else if let error = accountViewModel.errorMessage {
                                    Text(error)
                                        .foregroundColor(.red)
                                } else {
                                    ForEach(accountViewModel.accountResults) { account in
                                        AccountCell(account: account)
                                    }
                                }
                            }
                            .padding(.top, 34)
                        }
                        
                        // 🔹 검색 결과 표시 (키워드)
                        if selectedButton == "키워드" {
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ], spacing: 16) {
                                    if keywordViewModel.isLoading {
                                        ProgressView()
                                    } else if let error = keywordViewModel.errorMessage {
                                        Text(error)
                                            .foregroundColor(.red)
                                    } else {
                                        ForEach(keywordViewModel.keywordResults) { keyword in
                                            KeywordCell(keyword: keyword)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding(.top, 34)
                        }
                    }
                    .transition(.opacity)
                }
            }
            Spacer()
        }
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
    }
}



#Preview {
    SearchView()
}
