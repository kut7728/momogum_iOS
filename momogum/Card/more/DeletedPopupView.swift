//
//  DeletedPopupView.swift
//  momogum
//
//  Created by 조승연 on 2/5/25.
//

import SwiftUI

struct DeletedPopupView: View {
    @Binding var showDeletedPopup: Bool
    @Binding var showPopup: Bool
    var onDismiss: () -> Void
    
    var body: some View {
        Text("삭제됨")
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.red)
            .frame(width: 140, height: 48)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .transition(.opacity)
            .offset(y: -60)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showDeletedPopup = false
                    showPopup = false
                    onDismiss()
                }
            }
    }
}
