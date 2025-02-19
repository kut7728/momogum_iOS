//
//  PopupMenuView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct PopupMenuView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showPopup: Bool
    @Binding var isTabBarHidden: Bool
    @Binding var showSavedPopup: Bool
    @State private var showDeleteConfirmation = false
    @State private var showDeletedPopup = false
    @State private var navigateToFixPostView = false
    
    var viewModel: MyCardViewModel
    var mealDiaryId: Int

    var body: some View {
        ZStack {
            if showDeleteConfirmation {
                DeleteConfirmView(
                    showDeleteConfirmation: $showDeleteConfirmation,
                    showDeletedPopup: $showDeletedPopup,
                    viewModel: viewModel,
                    mealDiaryId: mealDiaryId
                )
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            }

            if showDeletedPopup {
                DeletedPopupView(
                    showDeletedPopup: $showDeletedPopup,
                    isTabBarHidden: $isTabBarHidden,
                    showPopup: $showPopup
                ) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isTabBarHidden = false
                        dismiss()
                    }
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            }

            if !showDeleteConfirmation && !showDeletedPopup {
                VStack(spacing: 0) {
                    Button(action: {
                        showPopup = false
                        isTabBarHidden = true
                        navigateToFixPostView = true
                    }) {
                        Text("수정")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(Color.white)
                    }
                    
                    Divider()
                        .padding(.horizontal, 10)

                    Button(action: {
                        print("삭제 버튼 클릭")
                        showDeleteConfirmation = true
                    }) {
                        Text("삭제")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(Color.white)
                    }
                }
                .frame(width: 159, height: 104)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .position(x: UIScreen.main.bounds.width - 100, y: 120)
                .transition(.opacity)
            }
        }
        .navigationDestination(isPresented: $navigateToFixPostView) {
            FixPostView(isTabBarHidden: $isTabBarHidden, showSavedPopup: $showSavedPopup)
        }
    }
}
