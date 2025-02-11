//
//  SignupEndView.swift
//  momogum
//
//  Created by 서재민 on 2/12/25.
//

import SwiftUI

struct SignupEndView: View {
    @Binding var path: [Route]

    
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
            }
        }
    }
}

#Preview {
    SignupEndView(path: .constant([]))
}
