//
//  SwiftUIView.swift
//  momogum
//
//  Created by 서재민 on 1/11/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authViewModel = AuthViewModel()
    @FocusState private var isFocused: Bool // TextField의 포커스 상태
    @FocusState private var isFocusedPWD: Bool
    @State private var path: [Route] = [] //path 설정
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
                    authViewModel.handleKakaoLogin { success in
                        if success {
                            print("카카오 로그인 성공!")
                            
                            authViewModel.checkIsNewUser { isSuccess, isNew in
                                if isSuccess {
                                    if isNew {
                                        path.append(.SignupStartView)
                                        print("신규 유저입니다. 회원가입이 필요합니다.")
                                    } else {
                                        AuthManager.shared.isLoggedIn = true
                                        print("기존 유저 로그인 완료")
                                    }
                                } else {
                                    AuthManager.shared.isLoggedIn = true
                                    print("❌ 유저 확인 실패")
                                }
                            }  } else {
                                print(" 카카오 로그인 실패")
                            }
                    }
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
                    authViewModel.handleKakaoLogout()
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
        
        
    }


#Preview {
    LoginView()
}
