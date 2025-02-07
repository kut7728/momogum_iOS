//
//  SwiftUIView.swift
//  momogum
//
//  Created by 서재민 on 1/11/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var kakaoAuthViewModel : KakaoAuthViewModel = KakaoAuthViewModel()
    @FocusState private var isFocused: Bool // TextField의 포커스 상태
    @FocusState private var isFocusedPWD: Bool
    @State private var path: [String] = [] //path 설정
    
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
                KakaoAuthViewModel().handleKakaoLogin()
               
            }
            label: {
                Image("KakaoLogin")
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
           

            //회원가입뷰
            NavigationLink(value: "SignupStep1View"){
             
                HStack(spacing: 0) {
                    Text("계정이 없으신가요? ")
                        .foregroundColor(.primary) // 기본 색상
                    Text("회원가입하기")
                        .foregroundColor(Color.momogumRed) // 강조된 색상
                        .fontWeight(.bold) // 굵게 설정
                }
                .navigationDestination(for: String.self) { value in
                    if value == "SignupStep1View" {
                        SignupStep1View(path: $path)
                    }
                    else if value == "SignupStep2View" {
                        SignupStep2View(path: $path)
                    }
                }
                .foregroundStyle(.black)
                .background{
                    
                }
            }
            .padding()
            
            Spacer()
        }
    }
    
    
}

#Preview {
    LoginView()
}
