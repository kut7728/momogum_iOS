//
//  BellViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/9/25.
//

import Foundation
import SwiftUI
import Combine

class BellViewModel: ObservableObject {
    @Published var unreadCount: Int = 2 // 읽지 않은 알림 개수
    @Published var notifications: [NotificationModel] = NotificationModel.dummyNotifications // 더미 데이터

    init() {
        updateUnreadCount()
    }

    // 읽지 않은 알림 개수 업데이트
    func updateUnreadCount() {
        unreadCount = notifications.filter { !$0.isRead }.count
    }

    // 특정 알림을 읽음 처리
    func markAsRead(_ notification: NotificationModel) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
            updateUnreadCount()
        }
    }

    // 모든 알림을 읽음 처리
    func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
        updateUnreadCount()
    }
}

