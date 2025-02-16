//
//  UnfollowPopup.swift
//  momogum
//
//  Created by 류한비 on 2/13/25.
//

import SwiftUI

struct UnfollowPopup: View {
    @Binding var showPopup: Bool
    @Binding var showCompletedPopup: Bool
    
    var onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("팔로우 목록에서\n삭제하시겠습니까?")
                .font(.mmg(.subheader3))
                .foregroundColor(Color.red)
                .padding(.top, 37)
                .multilineTextAlignment(.center)
            
            Spacer().frame(width: 250, height: 37)
            
            Divider().frame(width: 234)
            
            Spacer().frame(width: 250, height: 14)
            
            HStack(alignment: .center, spacing: 0){
                // 취소
                Button {
                    showPopup = false
                } label: {
                    Text("취소")
                        .font(.mmg(.subheader3))
                        .foregroundColor(Color.black_2)
                }
                .padding(.trailing, 50)
                .padding(.top, 3)
                
                
                VerticalDivider()
                
                // 삭제
                Button {
                    showPopup = false
                    onRemove()
                    showCompletedPopup = true
                } label: {
                    Text("삭제")
                        .font(.mmg(.subheader3))
                        .foregroundColor(Color.red)
                }
                .padding(.leading, 50)
                .padding(.top, 3)
            }
        }
        .frame(width: 280, height: 200)
        .background(Color.black_6)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black_4, lineWidth: 1)
        )
    }
}
