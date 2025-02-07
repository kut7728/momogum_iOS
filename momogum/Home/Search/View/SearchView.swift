//
//  SearchView.swift
//  momogum
//
//  Created by 김윤진 on 1/21/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery: String = ""
    @State private var isEditing: Bool = false // 텍스트 필드 편집 상태를 추적
    @State private var selectedButton: String = "계정" // 초기 선택된 버튼
    @Environment(\.presentationMode) var presentationMode // 뒤로가기 기능을 위해 사용

    // 더미 데이터 추가
    let dummyAccounts = [
        Account(userID: "momogum._.", name: "머머금"),
        Account(userID: "john_doe", name: "John Doe"),
        Account(userID: "jane_smith", name: "Jane Smith")
    ]

    let dummyKeywords = [
        Keyword(title: "한식"),
        Keyword(title: "중식"),
        Keyword(title: "일식"),
        Keyword(title: "양식"),
        Keyword(title: "패스트푸드"),
        Keyword(title: "디저트")
    ]
    
    // 검색된 결과 필터링
    var filteredAccounts: [Account] {
        if searchQuery.isEmpty {
            return dummyAccounts
        } else {
            return dummyAccounts.filter {
                $0.userID.localizedCaseInsensitiveContains(searchQuery) ||
                $0.name.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    var filteredKeywords: [Keyword] {
        if searchQuery.isEmpty {
            return dummyKeywords
        } else {
            return dummyKeywords.filter {
                $0.title.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

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
                    
                    TextField("계정 및 키워드 검색", text: $searchQuery, onEditingChanged: { editing in
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
                                searchQuery = ""
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
                                selectedButton = "계정"
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
                        
                        // 🔹 검색 결과 표시
                        if selectedButton == "계정" {
                            VStack(spacing: 16) {
                                ForEach(filteredAccounts) { account in
                                    AccountCell(account: account)
                                }
                            }
                            .padding(.top, 34)
                        }
                        
                        if selectedButton == "키워드" {
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ], spacing: 16) {
                                    ForEach(filteredKeywords) { keyword in
                                        KeywordCell(keyword: keyword)
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
