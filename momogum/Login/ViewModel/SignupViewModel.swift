//
//  SignupViewModel.swift
//  momogum
//
//  Created by 서재민 on 2/6/25.
//
import Foundation
import Alamofire
import Combine


class SignupViewModel {
    
    
    var cancellables = Set<AnyCancellable>()
    
    // Combine을 사용하여 POST 요청 보내기
    
    func signupRequest(dataModel: SignupDataModel, token: String) {
        let baseUrl = "https://dev.momogum.shop/swagger-ui/index.html#/%EC%86%8C%EC%85%9C%20%EB%A1%9C%EA%B7%B8%EC%9D%B8%20%EB%B0%8F%20%EC%9D%B8%EC%A6%9D%20API/kakaoSignUp"
        let signupModel = SignupModel(accessToken: token, name: dataModel.name, nickname: dataModel.nickname)
        //매번 초기화가 되는지 의문

        // Alamofire의 Combine 지원을 사용하는 POST 요청
        AF.request(baseUrl, method: .post, parameters: signupModel, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: SignupResponseModel.self)
            .compactMap{ $0.value} //optional 언랩핑
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("요청이 완료되었습니다.")
                case .failure(let error):
                    print("오류 발생: \(error.localizedDescription)")
                }
            }, receiveValue: { (recievedValue : SignupResponseModel) in
                // 성공적인 응답 처리
//                if let responseModel = response.value {
//                    print("응답 성공: \(responseModel.isSuccess), \(responseModel.message)")
//                    // 예시: 응답에서 받은 accessToken
//                    print("Access Token: \(responseModel.result.accessToken)")
//                }
                
                
            })
            .store(in: &cancellables)  // Combine의 cancellable을 저장하여 메모리에서 관리
    }
}



