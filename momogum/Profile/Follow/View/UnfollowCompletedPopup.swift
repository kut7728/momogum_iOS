//
//  UnfollowCompletedPopup.swift
//  momogum
//
//  Created by 류한비 on 2/13/25.
//

import SwiftUI

struct UnfollowCompletedPopup: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("삭제되었습니다.")
                .font(.mmg(.subheader3))
                .foregroundColor(Color.black_2)
                .padding(.top, 48)
                .padding(.bottom, 48)
        }
        .frame(width: 319, height: 120)
        .background(Color.black_6)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black_4, lineWidth: 1)
        )
            
    }
}


#Preview {
    UnfollowCompletedPopup()
}
