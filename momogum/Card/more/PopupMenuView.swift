//
//  PopupMenuView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct PopupMenuView: View {
    @Binding var showPopup: Bool
    @Binding var isTabBarHidden: Bool
    @Binding var showSavedPopup: Bool
    @State private var showDeleteConfirmation = false
    @State private var showDeletedPopup = false
    @State private var navigateToFixPostView = false

    var body: some View {
        ZStack {
            if showDeleteConfirmation {
                DeleteConfirmView(showDeleteConfirmation: $showDeleteConfirmation, showDeletedPopup: $showDeletedPopup)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            }

            if showDeletedPopup {
                DeletedPopupView(showDeletedPopup: $showDeletedPopup, showPopup: $showPopup)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            }

            if !showDeleteConfirmation && !showDeletedPopup {
                VStack(spacing: 0) {
                    Button(action: {
                        showPopup = false
                        isTabBarHidden = true  // ✅ FixPostView로 이동할 때 탭바 숨김 적용
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
                .onAppear {
                    isTabBarHidden = true  // ✅ FixPostView로 이동 시 탭바 숨김 유지
                }
                .onDisappear {
                    isTabBarHidden = false  // ✅ 뒤로 가면 탭바 다시 보이게 복구
                }
        }
    }
}
