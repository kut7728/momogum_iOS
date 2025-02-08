//
//  ContentView.swift
//  momogum
//
//  Created by nelime on 1/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showMainView = false
    @State private var isLoggedIn = false  // 로그인 상태 관리
    @State var signupDataModel = SignupDataModel()
    var body: some View {
        ZStack{
            if showMainView{
                if isLoggedIn{
                    MainTabView()
                } else{
                    LoginView(isLoggedIn: $isLoggedIn)
                        .environment(signupDataModel)
                }
                
            } else{
                SplashView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation{
                                showMainView = true
                            }
                        }
                    }
            }
        }
    }
}
#Preview {
    ContentView()
}
