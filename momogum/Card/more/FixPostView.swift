//
//  FixPostView.swift
//  momogum
//
//  Created by 조승연 on 2/6/25.
//

import SwiftUI

struct FixPostView: View {
    @Environment(\ .dismiss) var dismiss
    @StateObject private var viewModel = FixPostViewModel()
    @Binding var isTabBarHidden: Bool
    @Binding var showSavedPopup: Bool

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Button(action: {
                            isTabBarHidden = false
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                        .frame(width: 44, height: 44)

                        Spacer()

                        Text("게시물 수정")
                            .font(.headline)
                            .foregroundColor(.black)

                        Spacer()

                        Button(action: {
                            showSavedPopup = true
                            dismiss()
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                        .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 60)
                    .background(Color.white)
                    .zIndex(1)
                }

                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        Spacer().frame(height: 38)

                        Image("cardExample")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                        
                        Spacer().frame(height: 40)

                        MealCategoryView(categories: ["한식", "중식", "일식", "양식", "아시안", "패스트푸드", "카페", "기타"], selectedCategory: $viewModel.fixPost.selectedCategory)

                        Spacer().frame(height: 32)

                        MealInputView(tags: $viewModel.fixPost.tags)
                            .padding(.top, 20)

                        Spacer().frame(height: 36)

                        MealPlaceView(mealPlace: $viewModel.fixPost.mealPlace)

                        Spacer().frame(height: 36)

                        MealExperienceView(newExperience: $viewModel.fixPost.newExperience)

                        Spacer().frame(height: 36)

                        MealIconView(selectedIcon: $viewModel.fixPost.selectedIcon)
                        
                        Spacer().frame(height: 36)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                isTabBarHidden = true
            }
        }
        .onDisappear {
            isTabBarHidden = false
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FixPostView(isTabBarHidden: .constant(false), showSavedPopup: .constant(false))
}
