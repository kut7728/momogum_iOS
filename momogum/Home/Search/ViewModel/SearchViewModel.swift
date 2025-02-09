//
//  SearchViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/9/25.
//

import Foundation
import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var selectedButton: String = "계정" // 기본 선택된 버튼
    
    // 더미 데이터
    private let dummyAccounts = [
        Account(userID: "momogum._.", name: "머머금"),
        Account(userID: "john_doe", name: "John Doe"),
        Account(userID: "jane_smith", name: "Jane Smith")
    ]
    
    private let dummyKeywords = [
        Keyword(title: "한식"),
        Keyword(title: "중식"),
        Keyword(title: "일식"),
        Keyword(title: "양식"),
        Keyword(title: "패스트푸드"),
        Keyword(title: "디저트")
    ]
    
    // 검색된 계정 리스트
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
    
    // 검색된 키워드 리스트
    var filteredKeywords: [Keyword] {
        if searchQuery.isEmpty {
            return dummyKeywords
        } else {
            return dummyKeywords.filter {
                $0.title.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    // 버튼 선택 변경
    func selectButton(_ button: String) {
        selectedButton = button
    }
    
    // 검색어 초기화
    func clearSearch() {
        searchQuery = ""
    }
}
