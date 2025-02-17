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
    
    @Published var comments: [Comment] = []
    @Published var showPopup = false
    @Published var showDeleteConfirm = false
    @Published var showDeleted = false
    @Published var showHeartBottomSheet = false
    
    struct Comment: Codable {
        let userProfileImagePath: String?
        let nickname: String
        let content: String
    }
    
    struct ResponseData: Codable {
        let isSuccess: Bool
        let code: String
        let message: String
        let result: String?
    }

    struct ResultData: Codable {
        let commentId: Int?
    }
    
    func fetchMealDiary(mealDiaryId: Int, userId: Int) {
        let url = "\(BaseAPI)/meal-diaries?mealDairyId=\(mealDiaryId)&userId=\(userId)"
        
        AF.request(url, method: .get)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let jsonString = String(data: data, encoding: .utf8) {
                             print("✅ API 응답: \(jsonString)")
                        }
                        
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                            let result = jsonObject["result"] as? [String: Any] {
                                
                            DispatchQueue.main.async {
                                let commentCount = result["mealDiaryCommentCount"] as? Int ?? 0
                                print("✅ 불러온 댓글 개수: \(commentCount)")
                                
                                self.myCard = MyCardModel(
                                    likeCount: result["mealDiaryLikeCount"] as? Int ?? 0,
                                    isLiked: result["like"] as? Bool ?? false,
                                    reviewText: result["review"] as? String ?? "",
                                    showBookmark: result["mealDairyBookmark"] as? Bool ?? false,
                                    mealDiaryImageURL: (result["mealDiaryImageLinks"] as? [String])?.first,
                                    isRevisit: result["isRevisit"] as? String ?? "NOT_GOOD",
                                    location: result["location"] as? String ?? "",
                                    keywords: result["keywords"] as? [String] ?? [],
                                    commentCount: commentCount,
                                    userProfileImageLink: result["userProfileImageLink"] as? String,
                                    nickname: result["nickname"] as? String ?? "유저아이디",
                                    mealDiaryCreatedAt: result["mealDiaryCreatedAt"] as? String ?? "날짜 없음"
                                )
                                if let commentsArray = result["comments"] as? [[String: Any]] {
                                    self.objectWillChange.send()
                                    self.comments = commentsArray.map { commentDict in
                                        Comment(
                                            userProfileImagePath: commentDict["userProfileImagePath"] as? String,
                                            nickname: commentDict["nickname"] as? String ?? "익명",
                                            content: commentDict["content"] as? String ?? ""
                                        )
                                    }
                                    print("✅ 불러온 댓글: \(self.comments)")
                                } else {
                                    print("❌ comments 배열 없음")
                                }
                            }
                        }
                    } catch {
                        print("❌ JSON 파싱 오류: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("❌ API 호출 실패: \(error.localizedDescription)")
                }
            }
    }
    
    func addComment(mealDiaryId: Int, comment: String) {
        let url = "\(BaseAPI)/meal-diaries/comments"
        let parameters: [String: Any] = [
            "userId": 1,
            "mealDiaryId": mealDiaryId,
            "comment": comment
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ResponseData.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        DispatchQueue.main.async {
                            let newComment = Comment(userProfileImagePath: nil, nickname: self.myCard.nickname, content: comment)
                            self.comments.append(newComment)
                        }
                    } else {
                        print("❌ 댓글 추가 실패: \(data.message)")
                    }
                case .failure(let error):
                    print("❌ 댓글 추가 실패: \(error.localizedDescription)")
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
    
    func deleteMealDiary(mealDiaryId: Int) {
        let url = "\(BaseAPI)/meal-diaries/mealDiaryId/\(mealDiaryId)/userId/1"
        AF.request(url, method: .delete)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print("✅ 삭제 응답 JSON: \(String(data: data, encoding: .utf8) ?? "")")
                case .failure(let error):
                    print("❌ 삭제 API 호출 실패: \(error.localizedDescription)")
                }
            }
    }
    
    func togglePopup() {
        withAnimation {
            showPopup.toggle()
        }
    }
    
    func toggleBookmarkAPI(mealDiaryId: Int) {
        let url = "\(BaseAPI)/meal-diaries/bookmarks/userId/1/mealDiaryId/\(mealDiaryId)"
        
        let newBookmarkState = !myCard.showBookmark

        AF.request(url, method: .post, encoding: JSONEncoding.default)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("✅ 북마크 API 응답: \(jsonString)")
                    }
                    do {
                        let decodedResponse = try JSONDecoder().decode(ResponseData.self, from: data)
                        DispatchQueue.main.async {
                            if decodedResponse.isSuccess {
                                self.myCard.showBookmark = newBookmarkState
                            } else {
                                print("❌ 북마크 실패: \(decodedResponse.message)")
                            }
                        }
                    } catch {
                        print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("❌ 북마크 API 호출 실패: \(error.localizedDescription)")
                }
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
    
    func deletePost(mealDiaryId: Int) {
        showDeleteConfirm = false
        deleteMealDiary(mealDiaryId: mealDiaryId)
    }
    
    func toggleHeartBottomSheet() {
        showHeartBottomSheet.toggle()
    }
}
