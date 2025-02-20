//
//  CardViewModel.swift
//  momogum
//
//  Created by 조승연 on 2/20/25.
//

import SwiftUI
import Alamofire

class CardViewModel: ObservableObject {
    @Published var card = CardModel(
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
    @Published var showReportSheet = false
    @Published var showCompletedAlert = false
    @Published var showHeartBottomSheet = false
    
    struct Comment: Codable {
        let userProfileImagePath: String?
        let nickname: String
        let content: String
    }
    
    struct ResponseData<T: Codable>: Codable {
        let isSuccess: Bool
        let code: String
        let message: String
        let result: T?
    }

    struct ResultData: Codable {
        let commentId: Int?
    }
    
    struct LikeUser: Codable {
        let userProfileImage: String?
        let nickname: String
        let name: String
    }

    struct LikeUsersResponse: Codable {
        let isSuccess: Bool
        let code: String
        let message: String
        let result: [LikeUser]?
    }
    
    struct ReportRequest: Codable {
        let userID: Int
        let mealDiaryId: Int
        let reportReason: String
    }

    @Published var likedUsers: [LikeUser] = []
    
    func fetchMealDiary(mealDiaryId: Int) {
        let userId = 9
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
                                
                                self.card = CardModel(
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
            "userId": 9,
            "mealDiaryId": mealDiaryId,
            "comment": comment
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ResponseData<ResultData>.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        DispatchQueue.main.async {
                            let newComment = Comment(userProfileImagePath: self.card.userProfileImageLink, nickname: self.card.nickname, content: comment)
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
        switch card.isRevisit {
        case "GOOD": return "good_fill"
        case "BAD": return "bad_fill"
        default: return "soso_fill"
        }
    }
    
    func deleteMealDiary(mealDiaryId: Int) {
        let url = "\(BaseAPI)/meal-diaries/mealDiaryId/\(mealDiaryId)/userId/9"
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
        let url = "\(BaseAPI)/meal-diaries/bookmarks/userId/9/mealDiaryId/\(mealDiaryId)"
        
        let currentBookmarkState = card.showBookmark // 기존 북마크 상태 저장
        let newBookmarkState = !currentBookmarkState  // 반전된 상태

        AF.request(url, method: .post, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ResponseData<String>.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        DispatchQueue.main.async {
                            self.card.showBookmark = newBookmarkState
                            print("✅ 북마크 상태 변경 성공: \(newBookmarkState)")
                        }
                    } else {
                        print("❌ 북마크 토글 실패: \(data.message)")
                    }
                case .failure(let error):
                    print("❌ 북마크 API 호출 실패: \(error.localizedDescription)")
                }
            }
    }
    
    func toggleBookmark() {
        card.showBookmark.toggle()
    }
    
    func toggleLikeAPI(mealDiaryId: Int) {
        let url = "\(BaseAPI)/meal-diaries/likes/userId/9/mealDiaryId/\(mealDiaryId)"

        let currentLikeState = card.isLiked  // 현재 좋아요 상태 저장
        let newLikeState = !currentLikeState   // 상태 반전

        AF.request(url, method: .post, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ResponseData<String>.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        DispatchQueue.main.async {
                            self.card.isLiked = newLikeState
                            self.card.likeCount += newLikeState ? 1 : -1
                            print("✅ 좋아요 상태 변경 성공: \(newLikeState), 좋아요 개수: \(self.card.likeCount)")
                        }
                    } else {
                        print("❌ 좋아요 토글 실패: \(data.message)")
                    }
                case .failure(let error):
                    print("❌ 좋아요 API 호출 실패: \(error.localizedDescription)")
                }
            }
    }
    
    func toggleLike() {
        card.isLiked.toggle()
        card.likeCount += card.isLiked ? 1 : -1
    }
    
    func resetLikeCount() {
        card.likeCount = 0
    }
    
    func confirmDelete() {
        showDeleteConfirm = true
    }
    
    func deletePost(mealDiaryId: Int) {
        showDeleteConfirm = false
        deleteMealDiary(mealDiaryId: mealDiaryId)
    }
    
    func reportMealDiary(mealDiaryId: Int, reason: String) {
        let url = "\(BaseAPI)/meal-diaries/report"
        let parameters = ReportRequest(userID: 9, mealDiaryId: mealDiaryId, reportReason: reason)

        print("📡 신고 API 요청 시작 - URL: \(url)")
        print("📡 신고 API 요청 - Parameters: \(parameters)")

        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: ResponseData<ResultData>.self) { response in
                switch response.result {
                case .success(let data):
                    print("✅ 신고 성공: \(data.message)")
                    self.showReportCompleted()
                case .failure(let error):
                    print("❌ 신고 API 호출 실패: \(error.localizedDescription)")
                    if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                        print("❌ 서버 응답 내용: \(errorString)")
                    }
                }
            }
    }
    
    func toggleReportSheet() {
        showReportSheet.toggle()
    }

    func showReportCompleted() {
        showReportSheet = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showCompletedAlert = true
        }
    }
    
    func fetchLikedUsers(mealDiaryId: Int) {
        let url = "\(BaseAPI)/meal-diaries/likes?mealDiaryId=\(mealDiaryId)"

        AF.request(url, method: .get)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("✅ 좋아요 회원 조회 API 응답: \(jsonString)")
                    }
                    
                    do {
                        let decodedResponse = try JSONDecoder().decode(LikeUsersResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            if decodedResponse.isSuccess {
                                self.likedUsers = decodedResponse.result ?? []
                            } else {
                                print("❌ 좋아요 회원 조회 실패: \(decodedResponse.message)")
                            }
                        }
                    } catch {
                        print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("❌ 좋아요 회원 조회 API 호출 실패: \(error.localizedDescription)")
                }
            }
    }
    
    func toggleHeartBottomSheet() {
        showHeartBottomSheet.toggle()
    }
}
