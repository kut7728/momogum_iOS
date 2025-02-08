//
//  FollowViewModel.swift
//  momogum
//
//  Created by 류한비 on 2/7/25.
//

import SwiftUI

@Observable
class FollowViewModel {
    var followerCount: Int
    var followingCount: Int
    
    var search: String = ""
    var loadedFollowers = 20 // 초기 로딩 개수
    var allFollowers: [String] = [] // 전체 팔로워 리스트
    var followingUsers: [String] = [] // 팔로우한 유저 목록
    
    // 검색된 팔로워 목록
    var filteredFollowers: [String] {
        if search.isEmpty {
            return Array(allFollowers.prefix(loadedFollowers)) // 검색어가 없으면 현재 로드된 만큼만 반환
        } else {
            return allFollowers.filter { $0.localizedCaseInsensitiveContains(search) } // 검색어가 포함된 데이터만 반환
        }
    }
    
    // 검색된 팔로잉 목록
    var filteredFollowing: [String] {
        if search.isEmpty {
            return followingUsers
        } else {
            return followingUsers.filter { $0.localizedCaseInsensitiveContains(search) }
        }
    }
    
    init(followerCount: Int = 6325, followingCount: Int = 0) {
        self.followerCount = followerCount
        self.followingCount = followingCount
        generateFollowers() // 팔로워 목록 초기화
    }
    
    // 더미 데이터 생성 (테스트용)
    func generateFollowers() {
        allFollowers = (0..<followerCount).map { "유저 아이디\($0 + 1)" }
    }
    
    // 팔로우 상태 확인
    func isFollowing(_ userID: String) -> Bool {
        return followingUsers.contains(userID)
    }
    
    // 팔로우
    func follow(_ userID: String) {
        if !followingUsers.contains(userID) {
            followingUsers.append(userID)
            followingCount += 1
        }
    }
    
    // 언팔로우 (리스트에서 삭제)
    func unfollow(_ userID: String) {
        if let index = followingUsers.firstIndex(of: userID) {
            followingUsers.remove(at: index)
            followingCount -= 1
            //            removeFollower(userID) // 리스트에서 삭제
        }
    }
    
    // 팔로워 삭제
    func removeFollower(_ userID: String) {
        allFollowers.removeAll { $0 == userID }
        followerCount -= 1
    }
    
    // 더 많은 팔로워 로드
    func loadMoreFollowers() {
        let nextBatch = min(loadedFollowers + 20, allFollowers.count)
        if loadedFollowers < nextBatch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loadedFollowers = nextBatch
            }
        }
    }
}
