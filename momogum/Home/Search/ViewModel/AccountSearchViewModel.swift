//
//  AccountSearchViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/10/25.
//

import Foundation
import Combine

class AccountSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var accountResults: [AccountSearchResult] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    
    private var BaseAPI: String {
        return Bundle.main.object(forInfoDictionaryKey: "BASE_API") as? String ?? ""
    }

    // 계정 검색 API 호출
    func searchAccounts() {
        guard !searchQuery.isEmpty else {
            self.errorMessage = "검색어를 입력하세요."
            return
        }

        isLoading = true
        errorMessage = nil

        guard var urlComponents = URLComponents(string: "\(BaseAPI)/search/account") else {
            self.errorMessage = "잘못된 URL입니다."
            isLoading = false
            return
        }

        urlComponents.queryItems = [URLQueryItem(name: "request", value: searchQuery)]

        guard let url = urlComponents.url else {
            self.errorMessage = "URL 생성 실패"
            isLoading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: AccountSearchAPIResponse.self, decoder: JSONDecoder())
            .map { $0.result }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "계정 검색 실패: \(error.localizedDescription)"
                }
            }, receiveValue: { results in
                self.accountResults = results
            })
            .store(in: &cancellables)
    }

    // 검색어 초기화 메서드 추가
    func clearSearch() {
        self.searchQuery = ""
        self.accountResults = []
        self.errorMessage = nil
    }
}
