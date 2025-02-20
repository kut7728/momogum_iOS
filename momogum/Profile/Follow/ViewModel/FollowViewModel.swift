//
//  FollowViewModel.swift
//  momogum
//
//  Created by 류한비 on 2/7/25.
//

import SwiftUI
import Combine

class FollowViewModel: ObservableObject {
    @Published var followingUsers: [FollowingUser] = []  // 팔로우한 유저 리스트
    @Published var followingStatus: [String: Bool] = [:] // 유저 ID별 팔로우 여부
    
    @Published var followerCount: Int
    @Published var followingCount: Int
    
    @Published var search: String = ""
    @Published var loadedFollowers = 20 // 초기 로딩 개수
    @Published var allFollowers: [Follower] = [] // 팔로워 목록
    @Published var followUsers: [String] = [] // 팔로우한 유저 목록
    private var pendingUnfollow: [String] = [] // 언팔로우 예약된 유저 목록
    
    init() {
        self.followerCount = 0
        self.followingCount = 0
    }
    
    // MARK: - 검색
    
    // 검색된 팔로워 목록
    var filteredFollowers: [Follower] {
        if search.isEmpty {
            return Array(allFollowers.prefix(loadedFollowers)) // 검색어가 없으면 현재 로드된 만큼만 반환
        } else {
            return allFollowers.filter {
                $0.nickname.localizedCaseInsensitiveContains(search) ||
                $0.name.localizedCaseInsensitiveContains(search) // 닉네임 + 이름 검색
            }
        }
    }
    
    // 검색된 팔로잉 목록
    var filteredFollowing: [FollowingUser] {
        if search.isEmpty {
            return followingUsers // 검색어가 없으면 전체 반환
        } else {
            return followingUsers.filter {
                $0.nickname.localizedCaseInsensitiveContains(search) ||
                $0.name.localizedCaseInsensitiveContains(search) // 닉네임 + 이름 검색
            }
        }
    }
    
    // 팔로우 상태 확인
    func isFollowing(_ userID: String) -> Bool {
        return followUsers.contains(userID) && !pendingUnfollow.contains(userID)
    }
    
    // MARK: - Follower
    
    // 즉시 반영되는 팔로우 (Follower)
    func follow(_ userID: String) {
        if pendingUnfollow.contains(userID) {
            pendingUnfollow.removeAll { $0 == userID } // 예약된 언팔로우 취소
            followingCount += 1 // 예약된 언팔로우가 취소된 경우 다시 카운트 증가
        }
        if !followUsers.contains(userID) {
            followUsers.append(userID) // 리스트에 다시 추가
            followingCount += 1
        }
    }
    
    
    // 즉시 반영되는 언팔로우 (Follower)
    func unfollow(_ userID: String) {
        if let index = followUsers.firstIndex(of: userID) {
            followUsers.remove(at: index)
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
        followUsers.removeAll { pendingUnfollow.contains($0) }
        pendingUnfollow.removeAll() // 초기화
    }
    
    //    // 팔로워 삭제
    func removeFollower(_ userID: Int) {
        allFollowers.removeAll { $0.userId == userID } // userId 기준으로 삭제
        followerCount = allFollowers.count // 팔로워 수 업데이트
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
    
    
    //MARK: - Follow Toggle
    // 팔로우 토글
    func toggleFollow(userId: Int, targetUserId: String) {
        guard let url = URL(string: "\(BaseAPI)/follows/\(userId)/follow/\(targetUserId)/toggle") else {
            print("❌ 유효하지 않은 URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 팔로우 토글 실패: \(error.localizedDescription)")
                return
            }
            
            // 응답 데이터가 있는지 확인
            guard let data = data else {
                print("❌ 응답 데이터 없음")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(FollowResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.isSuccess {
                        let followingStatus = !(self.followingStatus[targetUserId] ?? false)
                        self.followingStatus[targetUserId] = followingStatus
                        
                        NotificationCenter.default.post(
                            name: Notification.Name("FollowStatusChanged"),
                            object: nil,
                            userInfo: ["userID": targetUserId, "isFollowing": followingStatus]
                        )
                        
                        print("✅ 팔로우 상태 변경됨: \(targetUserId) - \(followingStatus ? "팔로우 중" : "언팔로우됨")")
                    } else {
                        print("❌ API 요청 실패: \(decodedResponse.message)")
                    }
                }
            } catch {
                print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    // 유저 ID별 팔로우 여부 로드
    func fetchFollowStatus(userId: Int, targetUserIds: [String]) {
        for targetUserId in targetUserIds {
            guard let targetIntId = Int(targetUserId) else { continue }
            
            UserProfileManager.shared.toggleFollow(userId: userId, targetUserId: targetIntId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.followingStatus[targetUserId] = true // 현재 팔로우 상태를 저장
                    case .failure:
                        self.followingStatus[targetUserId] = false // 실패하면 기본적으로 false 처리
                    }
                }
            }
        }
    }
    
    
    
    // 팔로잉 목록 불러오기
    func fetchFollowingList(userId: Int) {
        guard let url = URL(string: "\(BaseAPI)/follows/\(userId)/search/following") else {
            print("❌ 유효하지 않은 URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 팔로잉 목록 요청 실패: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ 응답 데이터 없음")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(FollowingListResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.isSuccess {
                        self.followingUsers = decodedResponse.result
                        self.followingCount = self.followingUsers.count
                        
                        // 팔로우 상태 저장
                        self.updateFollowingStatus()
                    } else {
                        print("❌ API 요청 실패: \(decodedResponse.message)")
                    }
                }
            } catch {
                print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    
    
    
    // 팔로워 목록 불러오기
    func fetchFollowerList(userId: Int) {
        guard let url = URL(string: "\(BaseAPI)/follows/\(userId)/search/followers") else {
            print("❌ 유효하지 않은 URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 팔로워 목록 요청 실패: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ 응답 데이터 없음")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(FollowerListResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.isSuccess {
                        self.allFollowers = decodedResponse.result
                        self.followerCount = self.allFollowers.count

                        // 팔로우 상태 저장
                        self.updateFollowingStatus()
                    } else {
                        print("❌ API 요청 실패: \(decodedResponse.message)")
                    }
                }
            } catch {
                print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func updateFollowingStatus() {
        for user in followingUsers {
            followingStatus["\(user.userId)"] = true
        }
        for user in allFollowers {
            if followingStatus["\(user.userId)"] == nil {
                followingStatus["\(user.userId)"] = false
            }
        }
    }
    
    // 팔로워 삭제
    func deleteFollower(userId: Int, followerId: Int) {
        guard let url = URL(string: "\(BaseAPI)/follows/\(userId)/delete/\(followerId)/toggle") else {
            print("❌ 유효하지 않은 URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 팔로워 삭제 실패: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ 응답 데이터 없음")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(FollowResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.isSuccess {
                        print("서버에서 팔로워 삭제 성공: \(followerId)")
                    } else {
                        print("❌ API 요청 실패: \(decodedResponse.message)")
                    }
                }
            } catch {
                print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
            }
        }.resume()
    }


}
