//
//  SignupStartView.swift
//  momogum
//
//  Created by 서재민 on 1/27/25.
//

import SwiftUI

struct SignupStartView: View {
    @Binding var path: [String]
    @State private var GoStep1 = false

    var body: some View {
        
        VStack{
            VStack{
                Text("머머금을 사용할 준비가 거의 다 됐어요!")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.momogumRed)
                    .font(.system(size: 28))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                Text("마지막으로 정보 입력을 하러 갈까요?")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.signupStartTextblack)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
            .padding(.leading, 44)
            .padding(.trailing, 60)
            .padding(.bottom, 101)
            
            Image("SignupStartLogo")
                .resizable()
                .frame(width:160,height:160)
            
            Spacer()
            
            Text("이 단계는 최초 로그인 시 한 번만 진행됩니다.")
                .fontWeight(.regular)
                .font(.system(size: 16))
                .foregroundStyle(.signupStartTextblack)
                .padding(.bottom, 84)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 55)
        }
        .padding(.top, 130)
        Spacer()
        
        NavigationLink(value: "SignupStep1View") {
            EmptyView()
        }
        .navigationDestination(for: String.self) { value in
            if value == "SignupStep1View" {
                SignupStep2View(path: $path)
            }
        }
        .onAppear {
            // 2초 후에 3View로 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                GoStep1 = true
            }
     }
    }
}

#Preview {
    SignupStartView(path: .constant([]))
}
