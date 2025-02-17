//
//  MyCardViewModel.swift
//  momogum
//
//  Created by 조승연 on 2/1/25.
//

import SwiftUI
import Alamofire

class MyCardViewModel: ObservableObject {
    @Published var myCard = MyCardModel(
        likeCount: 0,
        isLiked: false,
        reviewText: "",
        showBookmark: false,
        mealDiaryImageURL: nil,
        isRevisit: "NOT_GOOD",
        location: "",
        keywords: [],
        commentCount: 0,
        userProfileImageLink: nil,
        nickname: "",
        mealDiaryCreatedAt: ""
    )

    @Published var showPopup = false
    @Published var showDeleteConfirm = false
    @Published var showDeleted = false
    @Published var showHeartBottomSheet = false

    func fetchMealDiary(mealDiaryId: Int, userId: Int) {
        let url = "\(BaseAPI)/meal-diaries?mealDairyId=\(mealDiaryId)&userId=\(userId)"

        AF.request(url, method: .get)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        // ✅ 서버 응답 JSON 확인용
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("✅ 서버 응답 JSON: \(jsonString)")
                        }

                        // ✅ JSON을 Dictionary 형태로 변환
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let result = jsonObject["result"] as? [String: Any] {

                            DispatchQueue.main.async {
                                self.myCard = MyCardModel(
                                    likeCount: result["mealDiaryLikeCount"] as? Int ?? 0,
                                    isLiked: result["like"] as? Bool ?? false,
                                    reviewText: result["review"] as? String ?? "",
                                    showBookmark: result["mealDairyBookmark"] as? Bool ?? false,
                                    mealDiaryImageURL: (result["mealDiaryImageLinks"] as? [String])?.first,
                                    isRevisit: result["isRevisit"] as? String ?? "NOT_GOOD",
                                    location: result["location"] as? String ?? "",
                                    keywords: result["keywords"] as? [String] ?? [],
                                    commentCount: result["mealDiaryCommentCount"] as? Int ?? 0,
                                    userProfileImageLink: result["userProfileImageLink"] as? String,
                                    nickname: result["nickname"] as? String ?? "유저아이디",
                                    mealDiaryCreatedAt: result["mealDiaryCreatedAt"] as? String ?? "날짜 없음"
                                )
                            }
                        } else {
                            print("❌ JSON 파싱 실패: 예상된 형식과 다름")
                        }
                    } catch {
                        print("❌ JSON 파싱 오류: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("❌ API 호출 실패: \(error.localizedDescription)")
                }
            }
    }

    func getRevisitImage() -> String {
        switch myCard.isRevisit {
        case "GOOD": return "good_fill"
        case "BAD": return "bad_fill"
        default: return "soso_fill"
        }
    }

    func togglePopup() {
        withAnimation {
            showPopup.toggle()
        }
    }

    func toggleBookmark() {
        myCard.showBookmark.toggle()
    }
    
    func toggleLike() {
        myCard.isLiked.toggle()
        myCard.likeCount += myCard.isLiked ? 1 : -1
    }

    func resetLikeCount() {
        myCard.likeCount = 0
    }

    func confirmDelete() {
        showDeleteConfirm = true
    }

    func deletePost() {
        showDeleteConfirm = false
        showDeleted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showDeleted = false
        }
    }

    func toggleHeartBottomSheet() {
        showHeartBottomSheet.toggle()
    }
}
