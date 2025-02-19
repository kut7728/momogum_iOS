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
    
    // 기존 값 저장 (서버에서 받아온 초기 값)
    private var originalUserName: String = ""
    private var originalUserID: String = ""
    private var originalUserBio: String = ""
    
    // 기본 프로필 여부 체크
    var isDefaultProfileImage: Bool {
        return currentPreviewImage?.pngData() == UIImage(named: "defaultProfile")?.pngData()
    }
    
    var uuid: Int? {
        return AuthManager.shared.UUID
    }
    
    init() {
//    init(userId: Int) {
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
//        fetchUserProfile(userId: userId)
//        fetchMealDiaries(userId: userId)
//        fetchBookmarkedMealDiaries(userId: userId)
    }
}

// MARK: - API 요청

extension ProfileViewModel {
    // 유저 프로필 로드
    func fetchUserProfile(userId: Int) {
        UserProfileManager.shared.fetchUserProfile(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    self.userName = userProfile.name
                    self.userID = userProfile.nickname
                    self.userBio = userProfile.about ?? ""

                    self.originalUserName = userProfile.name
                    self.originalUserID = userProfile.nickname
                    self.originalUserBio = userProfile.about ?? ""

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
}

// MARK: - 프로필 이미지 관리

extension ProfileViewModel {
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
    
    // 기본 이미지로 임시 설정
    func setDefaultImage() {
        currentPreviewImage = UIImage(named: "defaultProfile")
    }
}

// MARK: - 프로필 편집 및 저장

extension ProfileViewModel {
    // 프로필 편집 확정 (완료 버튼 클릭 시 호출)
    func saveUserData(userId: Int) {
        DispatchQueue.main.async {
            // ✅ 기존 값과 비교하여 변경 여부 확인
            let isNameChanged = self.userName != self.originalUserName
            let isNicknameChanged = self.userID != self.originalUserID
            let isBioChanged = self.userBio != self.originalUserBio
            let isImageChanged = self.currentPreviewImage != self.profileImage

            // ✅ 변경된 값이 없으면 서버 요청을 생략
            if !isNameChanged && !isNicknameChanged && !isBioChanged && !isImageChanged {
                print("⚠️ 변경된 정보가 없으므로 서버 요청을 생략합니다.")
                return
            }

            // ✅ 변경된 값이 있을 경우 서버로 전송
            if isImageChanged {
                UserProfileManager.shared.uploadProfileImage(userId: userId, image: self.currentPreviewImage!) { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success(let uploadedImageUrl):
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

    
    // 프로필 편집 (이름,아이디,한줄소개)
    private func updateProfileInfo(userId: Int, imageUrl: String?) {
        var updatedParameters: [String: Any] = [
            "name": self.userName.isEmpty ? originalUserName : self.userName,
            "nickname": self.userID.isEmpty ? originalUserID : self.userID,
            "about": self.userBio.isEmpty ? originalUserBio : self.userBio
        ]

        if let imageUrl = imageUrl {
            updatedParameters["profileImage"] = imageUrl  // 서버에서 허용하는지 확인 필요
        }

        print("🔍 서버로 보낼 최종 데이터: \(updatedParameters)")

        UserProfileManager.shared.updateUserProfile(userId: userId, parameters: updatedParameters) { result in
            switch result {
            case .success:
                print("✅ 프로필 업데이트 성공")
                self.profileImage = self.currentPreviewImage
            case .failure(let error):
                print("❌ 프로필 업데이트 실패: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - 데이터 초기화

extension ProfileViewModel {
    // 밥일기 새로고침
    func refreshMealDiaries() {
        //        guard let userId = AuthManager.shared.UUID, !isFetchingMealDiaries else { return } //중복 실행 방지
        
        let userId = AuthManager.shared.UUID ?? 1
        guard !isFetchingMealDiaries else { return }
        isFetchingMealDiaries = true
        
        let group = DispatchGroup()
        
        // 작성한 밥일기 새로고침
        group.enter()
        UserProfileManager.shared.fetchMealDiaries(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newMealDiaries):
                    self.mealDiaries = newMealDiaries
                case .failure(let error):
                    print("❌ 밥일기 새로고침 실패: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        // 저장한 밥일기 새로고침
        group.enter()
        UserProfileManager.shared.fetchBookmarkedMealDiaries(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newBookmarkedMealDiaries):
                    self.bookmarkedMealDiaries = newBookmarkedMealDiaries
                case .failure(let error):
                    print("❌ 북마크된 밥일기 새로고침 실패: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isFetchingMealDiaries = false // 요청 완료 표시
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
    
}
