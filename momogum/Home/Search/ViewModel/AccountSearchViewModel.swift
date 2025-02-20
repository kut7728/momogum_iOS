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
    private let baseAPI = BaseAPI

    func searchAccounts(reset: Bool = false) {
        if reset {
            accountResults = [] // 검색 초기화
        }

        guard !searchQuery.isEmpty else {
            self.errorMessage = "검색어를 입력하세요."
            return
        }

        isLoading = true
        errorMessage = nil


        // AuthManager에서 UUID 가져오기 (이제 값이 nil일 수도 있음)
        guard let userUUID = AuthManager.shared.UUID else {
            self.errorMessage = "로그인이 필요합니다."
            isLoading = false
            return
        }

        let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseAPI)/search/account?request=\(encodedQuery)&userId=\(userUUID)"
        

        guard let url = URL(string: urlString) else {
            self.errorMessage = "잘못된 URL입니다."
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTaskPublisher(for: request)
            .map { response in
                return response.data
            }
            .decode(type: AccountSearchAPIResponse.self, decoder: JSONDecoder())
            .map { apiResponse in
                print("✅ [응답 데이터] 반환된 계정 개수: \(apiResponse.result.count)")
                
                return apiResponse.result
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    print("계정 검색 완료")
                case .failure(let error):
                    self.errorMessage = "계정 검색 실패: \(error.localizedDescription)"
                    print("❌ [오류] API 요청 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] results in
                guard let self = self else { return }
                self.accountResults = results
            })
            .store(in: &cancellables)
    }

    func clearSearch() {
        self.searchQuery = ""
        self.accountResults = []
        self.errorMessage = nil
    }
}
