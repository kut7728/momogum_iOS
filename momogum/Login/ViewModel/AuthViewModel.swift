import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

final class AuthViewModel: ObservableObject {
    @Published var isNewUser: Bool?
    @Published var errorMessage: String?
    @Published var isSignedUp = false
    @Published var isUsernameDuplicated: Bool? = nil // ✅ 중복 여부 저장
    @Published var kakaoAccessToken: String = ""
    @Published var signupData = SignupDataModel()

    ///
    ///
    ///
    ///
    ///신규회원 구분 함수 첫번째값은 통신성공여부, 둘째값은 실제 신규회원인지의 여부 newUser값
    func checkIsNewUser(completion: @escaping (Bool,Bool) -> Void) {
            guard !kakaoAccessToken.isEmpty else {
                print(" 카카오 액세스 토큰이 없습니다.")
                completion(false,false)
                return
            }

            let kakaoLoginModel = KakaoLoginModel(provider: "kakao", accessToken: kakaoAccessToken)

            AuthService.shared.checkIsNewUser(kakaoLoginModel: kakaoLoginModel) { result in
                switch result {
                case .success(let response):
                    print(" 유저 정보 확인 성공: \(response)")
                    AuthManager.shared.UUID = response.result.id //식별값 저장
                    self.isNewUser = response.result.newUser
                    completion(true,response.result.newUser)
                case .failure(let error):
                    print(" 유저 확인 실패: \(error.localizedDescription)")
                    completion(false,false)
                }
            }
        }
    
    
    

    
    func signup() {
        
        let signupModel = signupData.createSignupModel()
//        let accessToken = kakaoAccessToken
            AuthService.shared.signup(signupModel: signupModel) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if response.isSuccess {
                            self?.isSignedUp = true
                        } else {
                            self?.errorMessage = response.message
                        }
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
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
                    self.kakaoAccessToken = oauthToken.accessToken  //  accessToken 저장
                    completion(true)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(" 카카오 계정 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if let oauthToken = oauthToken {
                    print(" 카카오 계정 로그인 성공, accessToken: \(oauthToken.accessToken)")
                    self.kakaoAccessToken = oauthToken.accessToken  //  accessToken 저장
                    print(self.kakaoAccessToken)// 카카오 토큰값 저장됐는지 확인
                    completion(true)
                }
            }
        }
    }
    
    func checkUsernameisDuplicated() {
        AuthService.shared.checkDuplicateUsername(username: signupData.name) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let isDuplicated):
                       if isDuplicated {
                           print("중복확인: 사용자가 있습니다.")
                           self?.isUsernameDuplicated = isDuplicated
                           
                       }
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

}

