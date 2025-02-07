//
//  BellModels.swift
//  momogum
//
//  Created by 김윤진 on 2/7/25.
//

import Foundation

// 알림 유형 Enum
enum NotificationType {
    case like
    case comment
    case follow
}

// 알림 데이터 모델
struct NotificationModel: Identifiable {
    let id = UUID()
    var title: String
    var message: String
    var time: String
    var type: NotificationType
    var isFollowing: Bool
}

// 더미 데이터 생성
extension NotificationModel {
    static let dummyNotifications: [NotificationModel] = [
        NotificationModel(title: "@@님이 회원님의 게시물을 좋아합니다.", message: "n일 전", time: "2일 전", type: .like, isFollowing: false),
        NotificationModel(title: "@@님이 댓글을 남겼습니다.", message: "웨이팅 많이 걸리나요?!!!!", time: "n일 전", type: .comment, isFollowing: false),
        NotificationModel(title: "@@님이 회원님을 팔로우하기 시작했습니다.", message: "n일 전", time: "n일 전", type: .follow, isFollowing: false),
        NotificationModel(title: "@@님이 댓글을 남겼습니다.", message: "완전 맛있어보인다...🤤", time: "n분 전", type: .comment, isFollowing: false),
        NotificationModel(title: "@@님이 회원님을 팔로우하기 시작했습니다.", message: "n일 전", time: "n일 전", type: .follow, isFollowing: false)
    ]
}

