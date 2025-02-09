//
//  SwiftUIView.swift
//  momogum
//
//  Created by 서재민 on 1/11/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var kakaoAuthViewModel = KakaoAuthViewModel()
    @FocusState private var isFocused: Bool // TextField의 포커스 상태
    @FocusState private var isFocusedPWD: Bool
    @State private var path: [Route] = [] //path 설정
    @Binding var isLoggedIn: Bool
    var body: some View {
        
        NavigationStack(path: $path){
            
            Text("머머금과 함께 밥일기를 공유하고, 식사고민을 해결해요!")
                .font(.mmg(.subheader1))
                .foregroundStyle(.momogumRed)
                .padding(.top, 127)
                .padding(.leading, 46)
                .padding(.trailing, 22)
            
            
            Image("Momogum")
                .resizable()
                .frame(width: 160, height: 160)
                .padding(.horizontal,116)
                .padding(.top, 72)
                .padding(.bottom, 61)
            
            
            Button{
                Login()
//                kakaoAuthViewModel.handleKakaoLogin()
                print("Current path: \(path)")
//                path.append(.SignupStartView)
            }
            label: {
                Image("KakaoLogin")
            }

            .navigationDestination(for: Route.self) { route in
                switch route {
                case.SignupStartView:
                    SignupStartView(path: $path)
                    
                case.SignupStep1View:
                    SignupStep1View(path: $path)
                    
                case.SignupStep2View:
                    SignupStep2View(path: $path)
                    
                case.MainTabView:
                    MainTabView()
                }
                
            }
            
            
            Button{
                KakaoAuthViewModel().handleKakaoLogout()
                print("카카오 로그아웃 성공") 
            }
            label: {
                Image("appleSignin")
                    .resizable()
                    .frame(width: 300 ,height: 45)
            }

                Spacer()
            }
    }
    
    func Login() {
        
            if kakaoAuthViewModel.isNewUser {
                kakaoAuthViewModel.handleKakaoLogin { success in
                    if success, let token = kakaoAuthViewModel.oauthToken?.accessToken {
                        print("✅ 로그인 성공: \(token)")
                        path.append(.SignupStartView) // 신규 유저는 회원가입 화면으로 이동
                        print(kakaoAuthViewModel.isNewUser)
                    } else {
                        print("❌ 로그인 실패")
                    }
                }
            } else {
                if kakaoAuthViewModel.isNewUser == false{
                    isLoggedIn = true

                }
            }
        }

}


#Preview {
    LoginView(isLoggedIn: .constant(false))
}
