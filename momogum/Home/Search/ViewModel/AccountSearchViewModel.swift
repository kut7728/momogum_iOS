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
    private let baseAPI = BaseAPI  // ✅ `Const.swift`의 BaseAPI 사용

    func searchAccounts(reset: Bool = false) {
        if reset {
            accountResults = []
            print("🔹 [초기화] 기존 검색 결과 리스트를 초기화합니다.")
        }

        guard !searchQuery.isEmpty else {
            self.errorMessage = "검색어를 입력하세요."
            print("❌ [오류] 검색어가 비어 있습니다.")
            return
        }

        isLoading = true
        errorMessage = nil

        print("🔄 [진행 중] 계정 검색 API 요청 시작. 검색어: \(searchQuery)")

        // ✅ AuthManager에서 UUID 가져오기 (이제 값이 nil일 수도 있음)
        guard let userUUID = AuthManager.shared.UUID else {
            self.errorMessage = "로그인이 필요합니다."
            isLoading = false
            print("❌ [오류] UUID 값을 가져올 수 없습니다. 로그인 필요!")
            return
        }

        let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseAPI)/search/account?request=\(encodedQuery)&userId=\(userUUID)"
        
        print("🌍 [API 요청] 최종 URL: \(urlString)")

        guard let url = URL(string: urlString) else {
            self.errorMessage = "잘못된 URL입니다."
            isLoading = false
            print("❌ [오류] 최종 URL 생성 실패. URL 문자열: \(urlString)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTaskPublisher(for: request)
            .map { response in
                print("✅ [응답 수신] HTTP 응답 상태 코드: \((response.response as? HTTPURLResponse)?.statusCode ?? 0)")
                return response.data
            }
            .decode(type: AccountSearchAPIResponse.self, decoder: JSONDecoder())
            .map { apiResponse in
                print("✅ [응답 파싱] API 응답 성공 여부: \(apiResponse.isSuccess)")
                print("✅ [응답 데이터] 반환된 계정 개수: \(apiResponse.result.count)")
                return apiResponse.result
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    print("✅ [완료] 데이터 정상 수신 완료")
                case .failure(let error):
                    self.errorMessage = "계정 검색 실패: \(error.localizedDescription)"
                    print("❌ [오류] API 요청 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] results in
                guard let self = self else { return }
                self.accountResults = results
                print("📌 [결과 저장] 검색 결과 리스트 업데이트 완료 (총 \(results.count)개)")
            })
            .store(in: &cancellables)
    }

    func clearSearch() {
        self.searchQuery = ""
        self.accountResults = []
        self.errorMessage = nil
        print("🔹 [초기화] 검색어 및 결과 리스트 초기화 완료")
    }
}
