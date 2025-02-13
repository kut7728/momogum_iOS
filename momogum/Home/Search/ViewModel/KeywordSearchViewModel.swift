//
//  KeywordSearchViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/10/25.
//

import Foundation
import Combine

class KeywordSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var keywordResults: [KeywordSearchResult] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasMoreData: Bool = true

    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0  
    private let pageSize: Int = 6  // 6개씩 요청

    private var BaseAPI: String {
        return Bundle.main.object(forInfoDictionaryKey: "BASE_API") as? String ?? ""
    }

    // 키워드 검색 API 호출
    func searchKeywords(reset: Bool = false) {
        if reset {
            currentPage = 0
            hasMoreData = true
            keywordResults = []
        }

        guard !searchQuery.isEmpty, hasMoreData else { return }

        isLoading = true
        errorMessage = nil

        guard var urlComponents = URLComponents(string: "\(BaseAPI)/search/mealdiary") else {
            self.errorMessage = "잘못된 URL입니다."
            isLoading = false
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "request", value: searchQuery),
            URLQueryItem(name: "page", value: "\(currentPage)"),
            URLQueryItem(name: "size", value: "\(pageSize)")
        ]

        guard let url = urlComponents.url else {
            self.errorMessage = "URL 생성 실패"
            isLoading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: KeywordSearchAPIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "키워드 검색 실패: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                if response.result.isEmpty {
                    self.hasMoreData = false  // 더 이상 데이터가 없음
                } else {
                    self.keywordResults.append(contentsOf: response.result)
                    self.currentPage += 1  // 다음 페이지 번호 증가
                }
            })
            .store(in: &cancellables)
    }

    func clearSearch() {
        self.searchQuery = ""
        self.keywordResults = []
        self.errorMessage = nil
        self.currentPage = 0
        self.hasMoreData = true
    }
}
