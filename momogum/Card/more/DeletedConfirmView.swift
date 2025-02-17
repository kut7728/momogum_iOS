//
//  DeletedConfirmView.swift
//  momogum
//
//  Created by 조승연 on 2/6/25.
//

import SwiftUI

struct DeleteConfirmView: View {
    @Binding var showDeleteConfirmation: Bool
    @Binding var showDeletedPopup: Bool
    var viewModel: MyCardViewModel
    var mealDiaryId: Int
    
    var body: some View {
        VStack {
            Text("게시물을 삭제할까요?")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 20)
            
            Text("게시물 삭제 시 스토리에서도\n자동적으로 삭제됩니다.")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            Divider()
                .frame(height: 1)
                .background(Color.gray.opacity(0.3))
                .padding(.horizontal, 10)
                .padding(.top, 10)
            
            HStack(spacing: 0) {
                Button(action: {
                    showDeleteConfirmation = false
                }) {
                    Text("취소")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.white)
                }
                
                Divider()
                    .frame(width: 1, height: 52)
                    .background(Color.gray.opacity(0.3))
                
                Button(action: {
                    viewModel.deletePost(mealDiaryId: mealDiaryId)
                    showDeleteConfirmation = false
                    showDeletedPopup = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showDeletedPopup = false
                    }
                }) {
                    Text("삭제")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.white)
                }
            }
        }
        .frame(width: 304, height: 222)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .transition(.opacity)
        .offset(y: -60)
    }
}
