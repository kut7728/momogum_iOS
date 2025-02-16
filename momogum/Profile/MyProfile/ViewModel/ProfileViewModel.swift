//
//  ProfileViewModel.swift
//  momogum
//
//  Created by 류한비 on 1/20/25.
//

import SwiftUI
import Alamofire

@Observable
class ProfileViewModel {
    var profileImage: UIImage? // 확정된 프로필 이미지
    var currentPreviewImage: UIImage? // 편집 중에 보여지는 미리보기 이미지
    var uiImage: UIImage?
    
    // 기본 프로필 여부 체크
    var isDefaultProfileImage: Bool {
        return currentPreviewImage?.pngData() == UIImage(named: "defaultProfile")?.pngData()
    }
    
    // 유저 정보 (확정)
    var userName: String
    var userID: String
    var userBio: String
    
    // 유저 정보 (임시)
    var draftUserName: String
    var draftUserID: String
    var draftUserBio: String
    
    // 밥일기 리스트
    var mealDiaries: [ProfileMealDiary] = []
    
    // 북마크한 밥일기 리스트
    var bookmarkedMealDiaries: [ProfileMealDiary] = []
    
    init(userId: Int) {
        self.userName = "" // 임시
        self.userID = ""
        self.userBio = ""
        
        self.draftUserName = ""
        self.draftUserID = ""
        self.draftUserBio = ""
        
        self.profileImage = UIImage(named: "defaultProfile")
        self.currentPreviewImage = self.profileImage
        
        fetchUserProfile(userId: userId)
        fetchMealDiaries(userId: userId)
        fetchBookmarkedMealDiaries(userId: userId)
    }
    
    // 유저 프로필 로드
    func fetchUserProfile(userId: Int) {
        UserProfileManager.shared.fetchUserProfile(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    self.userName = userProfile.name
                    self.userID = userProfile.nickname
                    self.userBio = userProfile.about ?? ""
                    
                    self.draftUserName = self.userName
                    self.draftUserID = self.userID
                    self.draftUserBio = self.userBio
                    
                    // 프로필 이미지 로드
                    if let profileImageURL = userProfile.profileImage, !profileImageURL.isEmpty {
                        self.loadImageAsync(from: profileImageURL)
                    }
                case .failure(let error):
                    print("유저 프로필 로드 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 밥일기 로드
    func fetchMealDiaries(userId: Int) {
        UserProfileManager.shared.fetchMealDiaries(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let mealDiaries):
                    self.updateMealDiaries(with: mealDiaries)
                case .failure(let error):
                    print("밥일기 로드 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 북마크한 밥일기 로드
    func fetchBookmarkedMealDiaries(userId: Int) {
        UserProfileManager.shared.fetchBookmarkedMealDiaries(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookmarkedMealDiaries):
                    self.updateBookmarkedMealDiaries(with: bookmarkedMealDiaries)
                case .failure(let error):
                    print("북마크한 밥일기 로드 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 밥일기 업데이트 함수
    private func updateMealDiaries(with newMealDiaries: [ProfileMealDiary]) {
        self.mealDiaries = newMealDiaries
    }
    
    // 북마크한 밥일기 업데이트
    private func updateBookmarkedMealDiaries(with newBookmarkedMealDiaries: [ProfileMealDiary]) {
        self.bookmarkedMealDiaries = newBookmarkedMealDiaries
    }
    
    // 프로필 이미지 로드
    private func loadImageAsync(from urlString: String) {
        AF.request(urlString)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let imageData):
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.profileImage = image
                            self.currentPreviewImage = image
                        }
                    }
                case .failure(let error):
                    print("프로필 이미지 로드 실패: \(error.localizedDescription)") // 백에서 해결중
                }
            }
    }
    
    // 임시 프로필 이미지 변경
    func convertPreviewImage(from uiImage: UIImage) {
        DispatchQueue.main.async {
            self.currentPreviewImage = uiImage
        }
    }
    
    
    // 프로필 편집 확정 (완료 버튼 클릭 시 호출)
    func saveUserData(userId: Int) {
        DispatchQueue.main.async {
            let updatedProfile = UserProfile(
                id: Int64(userId),
                name: self.draftUserName,
                nickname: self.draftUserID,
                about: self.draftUserBio,
                profileImage: nil,
                newUser: false
            )
            
            UserProfileManager.shared.updateUserProfile(userId: userId, updatedProfile: updatedProfile) { result in
                switch result {
                case .success:
                    print("✅ 프로필 업데이트 성공")
                    self.profileImage = self.currentPreviewImage
                    self.userName = self.draftUserName
                    self.userID = self.draftUserID
                    self.userBio = self.draftUserBio
                case .failure(let error):
                    print("❌ 프로필 업데이트 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // 편집 취소 시 초기화
    func resetUserData() {
        currentPreviewImage = profileImage
        resetUserName()
        resetUserID()
        resetUserBio()
    }
    
    // 이름, 아이디, 한줄소개 각각 초기화
    func resetUserName() {
        draftUserName = userName
    }
    func resetUserID() {
        draftUserID = userID
    }
    func resetUserBio() {
        draftUserBio = userBio
    }
    
    // 기본 이미지로 임시 설정
    func setDefaultImage() {
        currentPreviewImage = UIImage(named: "defaultProfile")
    }
}
