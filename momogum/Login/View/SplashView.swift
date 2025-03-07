//
//  SplashView.swift
//  momogum
//
//  Created by 서재민 on 1/12/25.
//

import SwiftUI


//초기 화면
struct SplashView: View {
    var body: some View {
        ZStack {
            Color.momogumRed
                .edgesIgnoringSafeArea(.all)
            Image("SplashLogo")
                .resizable()
                .frame(width: 160, height: 160)
        }
    }
}

#Preview {
    SplashView()
}
