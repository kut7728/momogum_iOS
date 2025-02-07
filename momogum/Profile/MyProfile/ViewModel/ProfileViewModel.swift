//
//  ProfileViewModel.swift
//  momogum
//
//  Created by 류한비 on 1/20/25.
//

import SwiftUI

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
    
    init() {
        self.userName = ""
        self.userID = ""
        self.userBio = ""
        
        
        self.draftUserName = ""
        self.draftUserID = ""
        self.draftUserBio = ""
        
        self.profileImage = UIImage(named: "defaultProfile")
        self.currentPreviewImage = self.profileImage
        
        // 더미 데이터 적용
        if let dummyUser = UserProfileResponse.dummyUser.result {
            self.userName = dummyUser.name
            self.userID = dummyUser.nickname
            self.userBio = dummyUser.about
            self.draftUserName = self.userName
            self.draftUserID = self.userID
            self.draftUserBio = self.userBio
            
            // 프로필 이미지 로드
            if let profileImageURL = URL(string: dummyUser.profileImage) {
                loadImageAsync(from: profileImageURL)
            }
        }
    }
    
    // 이미지 로드
    private func loadImageAsync(from url: URL) {
        DispatchQueue.global(qos: .background).async {
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.profileImage = image
                    self.currentPreviewImage = image
                }
            }
        }
    }
    
    // 임시 프로필 이미지 변경
    func convertPreviewImage(from uiImage: UIImage) {
        self.currentPreviewImage = uiImage
        self.uiImage = uiImage
    }
    
    // 확정 (완료 버튼 클릭 시 호출)
    func saveUserData() {
        DispatchQueue.main.async { [self] in
            profileImage = currentPreviewImage
            userName = draftUserName
            userID = draftUserID
            userBio = draftUserBio
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
