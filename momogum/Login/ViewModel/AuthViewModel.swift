import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

final class AuthViewModel: ObservableObject {
    @Published var isNewUser: Bool?
    @Published var errorMessage: String?
    @Published var isSignedUp = false
    @Published var isUsernameDuplicated: Bool? = nil //  중복 여부 저장
    @Published var signupData : SignupDataModel

    init(signupData: SignupDataModel) {
            self.signupData = signupData
        }
    ///
    ///
    ///
    ///
    ///신규회원 구분 함수 첫번째값은 통신성공여부, 둘째값은 실제 신규회원인지의 여부 newUser값
    /// 신규 유저 확인 로직
       func checkIsNewUser(completion: @escaping (Bool, Bool) -> Void) {
           guard let accessToken = AuthManager.shared.KakaoAccessToken, !accessToken.isEmpty else {
               print(" 저장된 카카오 액세스 토큰이 없음")
               completion(false, false)
               return
           }

           let kakaoLoginModel = KakaoLoginModel(provider: "kakao", accessToken: accessToken)
           print("🛠️ 전송할 데이터: \(kakaoLoginModel)")

           AuthService.shared.checkIsNewUser(kakaoLoginModel: kakaoLoginModel) { result in
                   switch result {
                   case .success(let response):
                       print(" 유저 정보 확인 성공: \(response)")

                       switch response.result {
                                   case .user(let userResult):  // 신규 유저인 경우
                                       AuthManager.shared.UUID = userResult.id //추후 아이디 가져오는 방법 바꿀예정
                                       self.isNewUser = userResult.newUser // 신규유저인경우 true값 반환
                                    
                                       completion(true, userResult.newUser)

                                   case .token(let tokenResult):  // 기존 유저인 경우
                                       print("기존 유저 로그인 - 액세스 토큰 저장")
                                       AuthManager.shared.KakaoAccessToken = tokenResult.accessToken
                                       AuthManager.shared.KakaoRefreshToken = tokenResult.refreshToken
                                       completion(true, false)
                                   }


                   case .failure(let error):
                       print(" 유저 확인 실패: \(error.localizedDescription)")
                       completion(false, false)
                   }
               
           }
       }

    
    func resetSignupData() {
        self.signupData.name = ""
        self.signupData.nickname = ""
        self.isUsernameDuplicated = nil
    }
    

    
    func signup() {
        guard let accessToken = AuthManager.shared.KakaoAccessToken, !accessToken.isEmpty else {
            print(" 저장된 카카오 액세스 토큰이 없음")
            return
        }
        let signupModel = SignupModel(accessToken: accessToken, name: signupData.name, nickname: signupData.nickname)

        
            AuthService.shared.signup(signupModel: signupModel) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if response.isSuccess {
                            self?.isSignedUp = true
                            self?.resetSignupData()
                            print("회원가입 성공")
                        } else { 
                            self?.errorMessage = response.message
                            print("중복된 ID")
                        }
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        print("회원가입 실패")
                    }
                }
            }
        }
    

    func handleKakaoLogin(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(" 카카오톡 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if let oauthToken = oauthToken {
                    print("카카오톡 로그인 성공, accessToken: \(oauthToken.accessToken)")
                    AuthManager.shared.KakaoAccessToken = oauthToken.accessToken  //  accessToken 저장
                    AuthManager.shared.KakaoRefreshToken = oauthToken.refreshToken
                    print(" 카카오 액세스 토큰 저장 완료: \(AuthManager.shared.KakaoAccessToken ?? "없음")")
                    completion(true)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(" 카카오 계정 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if let oauthToken = oauthToken {
                    DispatchQueue.main.async {
                        print(" 카카오 계정 로그인 성공, accessToken: \(oauthToken.accessToken)")
                        AuthManager.shared.KakaoAccessToken = oauthToken.accessToken  //  accessToken 저장
                        AuthManager.shared.KakaoRefreshToken = oauthToken.refreshToken

                        print(" 카카오 액세스 토큰 저장 완료: \(AuthManager.shared.KakaoAccessToken ?? "없음")")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func checkUsernameisDuplicated() {
        AuthService.shared.checkDuplicateUsername(username: signupData.nickname) { [weak self] result in
            DispatchQueue.main.async {
                   switch result {
                   case .success(let isDuplicated):
                       if isDuplicated { // 중복 값이 true면
                           print(isDuplicated)
                           print("중복확인: 사용자가 있습니다.")
                           self?.isUsernameDuplicated = isDuplicated
                           
                       } //false면
                       else if !isDuplicated{
                           print("중복확인: 사용 가능한 아이디입니다!")
                           self?.isUsernameDuplicated = isDuplicated
                       }
                       
                   case .failure:
                       print("api 통신에러")
                       self?.isUsernameDuplicated = nil
                   }
               }
           }
       }
    
    
    func handleKakaoLogout(){
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }

    func fetchUserUUID() {
        AuthService.shared.fetchUUID(token: AuthManager.shared.KakaoAccessToken ?? "") { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let response):
                       print(" UUID 조회 성공: \(response)")
                    AuthManager.shared.UUID = response.result.id

                   case .failure(let error):
                       print(" UUID 조회 실패: \(error.localizedDescription)")
                       self?.errorMessage = error.localizedDescription
                   }
               }
           }
       }
    
    
//     토큰 저장: AuthManager.shared.kakaoAccessToken = oauthToken.accessToken
//     토큰 가져오기: AuthManager.shared.kakaoAccessToken
//     토큰 삭제: AuthManager.shared.kakaoAccessToken = nil
//     자동 로그인: checkAutoLogin()
}

