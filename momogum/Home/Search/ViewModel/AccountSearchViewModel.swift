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
    func searchAccounts(reset: Bool = false) {
        if reset {
            accountResults = []
        }
        
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

        // 현재 로그인한 사용자의 UUID
        let userUUID = String(AuthManager.shared.UUID!)

        urlComponents.queryItems = [
            URLQueryItem(name: "request", value: searchQuery),
            URLQueryItem(name: "userId", value: userUUID)
        ]

        guard let url = urlComponents.url else {
            self.errorMessage = "URL 생성 실패"
            isLoading = false
            return
        }

        print("🔹 계정 검색 API 요청 URL: \(url)") // 디버깅용 요청 URL 출력

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: AccountSearchAPIResponse.self, decoder: JSONDecoder())
            .map { $0.result }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return } // weak self 처리
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "계정 검색 실패: \(error.localizedDescription)"
                    print("❌ API 요청 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] results in
                guard let self = self else { return } // weak self 처리
                self.accountResults = results
            })
            .store(in: &cancellables)

    }

    // 검색어 초기화 시 리스트도 초기화
    func clearSearch() {
        self.searchQuery = ""
        self.accountResults = []
        self.errorMessage = nil
        print("🔹 검색어 및 결과 초기화 완료")
    }
}
