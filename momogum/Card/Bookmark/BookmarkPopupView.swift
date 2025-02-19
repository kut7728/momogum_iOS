//
//  BookmarkPopUpView.swift
//  momogum
//
//  Created by 조승연 on 2/18/25.
//

import SwiftUI

struct BookmarkPopupView: View {
    @Binding var showBookmarkText: Bool

    var body: some View {
        if showBookmarkText {
            Text("저장됨")
                .font(.system(size: 16))
                .foregroundColor(.red)
                .frame(width: 134, height: 46)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 2)
                )
                .transition(.opacity)
                .position(x: UIScreen.main.bounds.width / 2, y: 350)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showBookmarkText = false
                        }
                    }
                }
        }
    }
}
