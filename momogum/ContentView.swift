//
//  ContentView.swift
//  momogum
//
//  Created by nelime on 1/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showMainView = false
    @ObservedObject var authManager = AuthManager.shared
    @State var signupDataModel = SignupDataModel()
    var body: some View {
        ZStack{
            if showMainView{
                if authManager.isLoggedIn{
                    MainTabView()
                    
                } else{
                    LoginView()
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
