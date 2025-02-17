//
//  CommentViewModel.swift
//  momogum
//
//  Created by 조승연 on 2/17/25.
//

import SwiftUI
import Alamofire

class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    
    struct Comment: Codable {
        let username: String
        let content: String
        let time: String
        var isHighlighted: Bool
    }
    
    struct ResponseData: Codable {
        let isSuccess: Bool
        let code: String
        let message: String
        let result: ResultData?
    }

    struct ResultData: Codable {
        let commentId: Int?
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
                    print("🔹 서버 응답 데이터: \(data)")
                    if data.isSuccess {
                        DispatchQueue.main.async {
                            let newComment = Comment(username: "내 아이디", content: comment, time: "방금", isHighlighted: false)
                            self.comments.append(newComment)
                        }
                    } else {
                        print("❌ 댓글 추가 실패: \(data.message)")
                    }
                case .failure(let error):
                    if let data = response.data {
                        let responseString = String(data: data, encoding: .utf8) ?? "디코딩 불가"
                        print("❌ 서버 응답 오류: \(responseString)")
                    }
                    print("❌ 댓글 추가 실패: \(error.localizedDescription)")
                }
            }
    }
}
