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

    private let baseAPI = BaseAPI  // ✅ `Const.swift`의 BaseAPI 사용

    // 키워드 검색 API 호출
    func searchKeywords(reset: Bool = false) {
        if reset {
            currentPage = 0
            hasMoreData = true
            keywordResults = []
            print("🔄 [초기화] 검색어 초기화 및 첫 페이지 요청 시작")
        }

        guard !searchQuery.isEmpty, hasMoreData else {
            print("⚠️ [요청 차단] 검색어가 비어 있거나, 더 이상 불러올 데이터가 없습니다.")
            return
        }

        isLoading = true
        errorMessage = nil

        let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseAPI)/search/mealdiary?request=\(encodedQuery)&page=\(currentPage)"

        print("🌍 [API 요청] 최종 URL: \(urlString) (페이지: \(currentPage))")

        guard let url = URL(string: urlString) else {
            self.errorMessage = "잘못된 URL입니다."
            isLoading = false
            print("❌ [오류] URL 생성 실패. URL 문자열: \(urlString)")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { response in
                print("✅ [응답 수신] HTTP 응답 상태 코드: \((response.response as? HTTPURLResponse)?.statusCode ?? 0)")
                return response.data
            }
            .decode(type: KeywordSearchAPIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "키워드 검색 실패: \(error.localizedDescription)"
                    print("❌ [오류] API 요청 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                let newDataCount = response.result.count
                
                if newDataCount == 0 {
                    self.hasMoreData = false  // 더 이상 데이터가 없음
                    print("⚠️ [알림] 추가 데이터 없음 (마지막 페이지 도달)")
                } else {
                    self.keywordResults.append(contentsOf: response.result)
                    self.currentPage += 1  // 페이지 증가
                    print("📌 [결과 저장] 새로운 데이터 \(newDataCount)개 추가 (총 \(self.keywordResults.count)개)")
                }
            })
            .store(in: &cancellables)
    }

    // 검색어 초기화
    func clearSearch() {
        self.searchQuery = ""
        self.keywordResults = []
        self.errorMessage = nil
        self.currentPage = 0
        self.hasMoreData = true
        print("🔹 [초기화] 검색어 및 결과 리스트 초기화 완료")
    }
}
