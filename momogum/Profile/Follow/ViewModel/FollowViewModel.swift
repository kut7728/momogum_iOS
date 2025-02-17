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
    private var pendingUnfollow: [String] = [] // 언팔로우 예약된 유저 목록
    
    
// MARK: - 검색
    
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
    
    init(followerCount: Int = 1325, followingCount: Int = 0) {
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
        return followingUsers.contains(userID) && !pendingUnfollow.contains(userID)
    }
    
    // MARK: - Follower
    
    // 즉시 반영되는 팔로우 (Follower)
    func follow(_ userID: String) {
        if pendingUnfollow.contains(userID) {
            pendingUnfollow.removeAll { $0 == userID } // 예약된 언팔로우 취소
            followingCount += 1 // 예약된 언팔로우가 취소된 경우 다시 카운트 증가
        }
        if !followingUsers.contains(userID) {
            followingUsers.append(userID) // 리스트에 다시 추가
            followingCount += 1
        }
    }

    
    // 즉시 반영되는 언팔로우 (Follower)
    func unfollow(_ userID: String) {
        if let index = followingUsers.firstIndex(of: userID) {
            followingUsers.remove(at: index)
            followingCount -= 1
        }
    }
    
    // MARK: - Following
    
    // 뒤로가기 시 반영되는 언팔로우 (Following)
    func delayedUnfollow(_ userID: String) {
        if !pendingUnfollow.contains(userID) {
            pendingUnfollow.append(userID)
            followingCount -= 1
        }
    }
    
    // 최신 팔로우 목록 갱신 (뒤로가기 버튼을 눌렀을 때 실행)
    func refreshFollowingList() {
        followingUsers.removeAll { pendingUnfollow.contains($0) }
        pendingUnfollow.removeAll() // 초기화
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
