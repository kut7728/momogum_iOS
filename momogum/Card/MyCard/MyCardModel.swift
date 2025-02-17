//
//  MyCardModel.swift
//  momogum
//
//  Created by 조승연 on 2/1/25.
//

import Foundation

struct MyCardModel {
    var likeCount: Int          // 좋아요 개수
    var isLiked: Bool           // 좋아요 여부
    var reviewText: String      // 리뷰 내용
    var showBookmark: Bool      // 북마크 여부
    var mealDiaryImageURL: String? // 이미지 URL
    var isRevisit: String       // 재방문 여부 ("GOOD", "BAD", "NOT_GOOD")
    var location: String        // 위치
    var keywords: [String]      // 키워드 리스트
    var commentCount: Int       // 댓글 개수
    var userProfileImageLink: String?   // 유저 프로필 이미지 URL
    var nickname: String        // 사용자 닉네임
    var mealDiaryCreatedAt: String      // 포스팅 날짜
}
