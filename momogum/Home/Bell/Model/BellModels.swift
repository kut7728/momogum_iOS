//
//  BellModels.swift
//  momogum
//
//  Created by 김윤진 on 2/7/25.
//

import Foundation

// 알림 유형 Enum
enum NotificationType: String {
    case like = "like"
    case comment = "comment"
    case follow = "follow"
}

struct NotificationModel: Identifiable {
    let id = UUID()
    var title: String
    var message: String
    var time: String
    var type: NotificationType
    var isFollowing: Bool
    var isRead: Bool

    // 더미 데이터
    static var dummyNotifications: [NotificationModel] = [
        NotificationModel(title: "새 댓글", message: "당신의 게시글에 새로운 댓글이 달렸습니다.", time: "5분 전", type: .comment, isFollowing: false, isRead: false),
        NotificationModel(title: "새 팔로워", message: "누군가 당신을 팔로우했습니다.", time: "1시간 전", type: .follow, isFollowing: true, isRead: false),
        NotificationModel(title: "좋아요", message: "당신의 게시글에 좋아요가 달렸습니다.", time: "3시간 전", type: .like, isFollowing: false, isRead: true)
    ]
}
