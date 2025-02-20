//
//  SignupEndView.swift
//  momogum
//
//  Created by 서재민 on 2/12/25.
//

import SwiftUI

struct SignupEndView: View {
    @Binding var path: [Route]
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack{
            Text("정보 입력 완료!")
                .fontWeight(.semibold)
                .foregroundStyle(.Red_2)
                .font(.system(size: 28))
                .padding(.top,152)
            Text("맛있는 순간을 머머금과 함께해요!")
                .font(.mmg(.subheader3))
                .padding(.top,12)
                .foregroundStyle(.signupStartTextblack)
            Image("SignupStartLogo")
                .resizable()
                .frame(width: 229, height: 229)
                .padding(.top,90)
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                path = []
                AuthManager.shared.isLoggedIn = true
//                authViewModel.checkIsNewUser { isSuccess, isNew in
//                    if isSuccess { //로그인 성공 true
//                        if isNew { 
//                            path = []
//                            print("newUser값이 false란 소리")
//                        } else { // true false  기존유저
//                            AuthManager.shared.isLoggedIn = true
//                            authViewModel.fetchUserUUID()
//                            print("신규 회원의 로그인 완료!")
//                        }
//                    } else {
//                        print(" 유저 확인 실패")
//                    }
//                }
            }
        }
    }
}

//#Preview {
//    SignupEndView(path: .constant([]))
//}
