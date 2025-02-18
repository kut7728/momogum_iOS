//
//  ProfileViewModel.swift
//  momogum
//
//  Created by 류한비 on 1/20/25.
//

import SwiftUI
import Combine
import Alamofire

class ProfileViewModel: ObservableObject {
    @Published var isLoaded = false // 중복 호출 방지 플래그
    @Published private var isFetchingMealDiaries = false // API 요청 중인지 확인
    @Published var profileImage: UIImage? // 확정된 프로필 이미지
    @Published var currentPreviewImage: UIImage? // 편집 중에 보여지는 미리보기 이미지
    @Published var userName: String
    @Published var userID: String
    @Published var userBio: String
    @Published var mealDiaries: [ProfileMealDiary] = []
    @Published var bookmarkedMealDiaries: [ProfileMealDiary] = []
    
    // 기본 프로필 여부 체크
    var isDefaultProfileImage: Bool {
        return currentPreviewImage?.pngData() == UIImage(named: "defaultProfile")?.pngData()
    }
    
    var uuid: Int? {
        return AuthManager.shared.UUID
    }
    
    init() {
        self.userName = ""
        self.userID = ""
        self.userBio = ""

        self.profileImage = UIImage(named: "defaultProfile")
        self.currentPreviewImage = self.profileImage
        
        guard let uuid = self.uuid else {
            print("⚠️ UUID가 없습니다. ProfileViewModel 초기화 중단")
            return
        }
        
        fetchUserProfile(userId: uuid)
        fetchMealDiaries(userId: uuid)
        fetchBookmarkedMealDiaries(userId: uuid)
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

                    // 프로필 이미지 로드
                    if let profileImageURL = userProfile.profileImage, !profileImageURL.isEmpty {
                        self.loadImageAsync(from: profileImageURL)
                    }
                case .failure(let error):
                    print("❌ 유저 프로필 로드 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 밥일기 로드
    func fetchMealDiaries(userId: Int) {
        guard !isFetchingMealDiaries && !isLoaded else {
            print("⚠️ 이미 밥일기 데이터를 불러왔거나 요청 중입니다.")
            return
        }
        
        isFetchingMealDiaries = true
        UserProfileManager.shared.fetchMealDiaries(userId: userId) { result in
            DispatchQueue.main.async {
                self.isFetchingMealDiaries = false
                
                switch result {
                case .success(let mealDiaries):
                    self.isLoaded = true
                    print("✅ 유저 \(userId)의 밥일기 로드 성공: \(mealDiaries.count)개")
                    self.mealDiaries = mealDiaries
                case .failure(let error):
                    print("❌ 유저 \(userId)의 밥일기 로드 실패: \(error.localizedDescription)")
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
                    self.bookmarkedMealDiaries = bookmarkedMealDiaries
                case .failure(let error):
                    print("❌ 북마크한 밥일기 로드 실패: \(error.localizedDescription)")
                }
            }
        }
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
                        print("✅ 프로필 이미지 로드 성공!")
                    }
                case .failure(let error):
                    print("❌ 프로필 이미지 로드 실패: \(error.localizedDescription)")
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
            if let newImage = self.currentPreviewImage, newImage != self.profileImage {
                UserProfileManager.shared.uploadProfileImage(userId: userId, image: newImage) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let uploadedImageUrl):
                        print("✅ 프로필 이미지 업로드 성공: \(uploadedImageUrl)")
                        self.updateProfileInfo(userId: userId, imageUrl: uploadedImageUrl)

                    case .failure(let error):
                        print("❌ 프로필 이미지 업로드 실패: \(error.localizedDescription)")
                    }
                }
            } else {
                self.updateProfileInfo(userId: userId, imageUrl: nil)
            }
        }
    }
    
    private func updateProfileInfo(userId: Int, imageUrl: String?) {
        let updatedProfile = UserProfile(
            id: Int64(userId),
            name: self.userName,
            nickname: self.userID,
            about: self.userBio,
            profileImage: imageUrl,
            newUser: false
        )
        
        UserProfileManager.shared.updateUserProfile(userId: userId, updatedProfile: updatedProfile) { result in
            switch result {
            case .success:
                print("✅ 프로필 업데이트 성공")
                self.profileImage = self.currentPreviewImage
            case .failure(let error):
                print("❌ 프로필 업데이트 실패: \(error.localizedDescription)")
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
        userName = userName
    }
    func resetUserID() {
        userID = userID
    }
    func resetUserBio() {
        userBio = userBio
    }
    
    // 기본 이미지로 임시 설정
    func setDefaultImage() {
        currentPreviewImage = UIImage(named: "defaultProfile")
    }
}
