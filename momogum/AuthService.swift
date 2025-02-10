import Foundation
import Alamofire


final class AuthService {
    static let shared = AuthService()
    private init() {}

    
    ///  신규 유저 확인 (API 요청)
    func checkIsNewUser(kakaoLoginModel: KakaoLoginModel, completion: @escaping (Result<IsNewUserResponseModel, APIError>) -> Void) {
        let url = "\(BaseAPI)/auth/login/kakao"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]

        AF.request(url, method: .post, parameters: kakaoLoginModel, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: IsNewUserResponseModel.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    completion(.failure(self.handleError(error: error, response: response)))
                }
            }
    }

    
    func signup(signupModel: SignupModel, completion: @escaping (Result<SignupResponseModel, APIError>) -> Void) {
            let url = "\(BaseAPI)/auth/signup/kakao" // 백엔드에서 정의한 회원가입 엔드포인트
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]

            AF.request(url, method: .post, parameters: signupModel, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .responseDecodable(of: SignupResponseModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        print(" 회원가입 성공")
                        print("🔹 isSuccess: \(data.isSuccess)")
                        print("🔹 message: \(data.message)")
                        completion(.success(data))
                        
                    case .failure(let error):
                        print("회원가입 실패")
                        print("🔹 error: \(error.localizedDescription)")
                        if let data = response.data {
                            let responseString = String(data: data, encoding: .utf8)
                            print("🔹 응답 바디: \(String(describing: responseString))")
                        }
                        completion(.failure(self.handleError(error: error, response: response)))
                    }
                }
        }
    
    
    
    
    ///  에러 핸들링 로직
    private func handleError<T>(error: AFError, response: DataResponse<T, AFError>) -> APIError {
          if let statusCode = response.response?.statusCode {
              return APIError.httpError(statusCode)
          }
          return APIError.networkError
      }
  }

enum APIError: Error {
    case httpError(Int)
    case networkError
    case decodingError
}
