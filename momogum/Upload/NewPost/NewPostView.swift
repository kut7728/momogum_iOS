//
//  NewPostView.swift
//  momogum
//
//  Created by 조승연 on 1/22/25.
//

import SwiftUI

struct NewPostView: View {
    @Binding var tabIndex: Int
    @Binding var isTabBarHidden: Bool
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = NewPostViewModel()
    
    let editedImage: UIImage
    let onReset: () -> Void

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Button(action: {
                            onReset()
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                        .frame(width: 44, height: 44)

                        Spacer()

                        Text("새 게시물")
                            .font(.headline)
                            .foregroundColor(.black)

                        Spacer()

                        Button(action: {
                            isTabBarHidden = false
                            if let window = UIApplication.shared.connectedScenes
                                .compactMap({ $0 as? UIWindowScene })
                                .flatMap({ $0.windows })
                                .first(where: { $0.isKeyWindow }) {
                                
                                let newRootVC = UIHostingController(rootView: MainTabView())
                                newRootVC.modalPresentationStyle = .fullScreen

                                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                                    window.rootViewController = newRootVC
                                })
                                window.makeKeyAndVisible()
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                        .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 60)
                }

                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .center, spacing: 0) {
                            Spacer().frame(height: 38)

                            GeometryReader { geometry in
                                Image(uiImage: editedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: geometry.size.width / editedImage.size.width * editedImage.size.height)
                                    .clipped()
                            }
                            .frame(height: UIScreen.main.bounds.width / editedImage.size.width * editedImage.size.height)
                            .padding(.bottom, 30)

                            Spacer().frame(height: 25)

                            MealCategoryView(
                                categories: ["한식", "중식", "일식", "양식", "아시안", "패스트푸드", "카페", "기타"],
                                selectedCategory: $viewModel.newPost.selectedCategory
                            )
                            .id("category")
                            .onChange(of: viewModel.newPost.selectedCategory) { _, _ in
                                withAnimation {
                                    scrollViewProxy.scrollTo("input", anchor: .top)
                                }
                            }

                            Spacer().frame(height: 30)

                            if viewModel.newPost.selectedCategory != nil {
                                MealInputView(tags: $viewModel.newPost.tags)
                                    .id("input")
                                    .transition(.opacity)
                                    .onChange(of: viewModel.newPost.tags) { _, _ in
                                        withAnimation {
                                            scrollViewProxy.scrollTo("place", anchor: .center)
                                        }
                                    }
                            }

                            Spacer().frame(height: 30)

                            if !viewModel.newPost.tags.isEmpty {
                                MealPlaceView(mealPlace: $viewModel.newPost.mealPlace)
                                    .id("place")
                                    .onSubmit {
                                        if !viewModel.newPost.mealPlace.isEmpty {
                                            withAnimation {
                                                scrollViewProxy.scrollTo("experience", anchor: .center)
                                            }
                                        }
                                    }
                            }

                            Spacer().frame(height: 30)

                            if !viewModel.newPost.mealPlace.isEmpty {
                                MealExperienceView(newExperience: $viewModel.newPost.newExperience)
                                    .id("experience")
                                    .onChange(of: viewModel.newPost.newExperience) { _, newValue in
                                        if !newValue.isEmpty {
                                            withAnimation {
                                                scrollViewProxy.scrollTo("icon", anchor: .center)
                                            }
                                        }
                                    }
                            }

                            Spacer().frame(height: 30)

                            if !viewModel.newPost.newExperience.isEmpty {
                                MealIconView(selectedIcon: $viewModel.newPost.selectedIcon)
                                    .id("icon")
                                    .onChange(of: viewModel.newPost.selectedIcon) { _, _ in
                                        if viewModel.newPost.selectedIcon != nil {
                                            withAnimation {
                                                scrollViewProxy.scrollTo("uploadButton", anchor: .bottom)
                                            }
                                        }
                                    }
                            }

                            if viewModel.newPost.selectedIcon != nil {
                                Button(action: {
                                    viewModel.setSelectedImage(editedImage) // 이미지 설정
                                    viewModel.uploadMealDiarySingleRequest(image: editedImage) { success in
                                        if success {
                                            DispatchQueue.main.async {
                                                isTabBarHidden = false
                                                dismiss()
                                            }
                                        } else {
                                            print("🚨 업로드 실패")
                                        }
                                    }
                                }) {
                                    Text(viewModel.isUploading ? "업로드 중..." : "밥일기 업로드 하기")
                                        .font(.system(size: 17, weight: .bold))
                                        .frame(width: 340, height: 58)
                                        .foregroundColor(.white)
                                        .background(viewModel.isUploading ? Color.gray : Color(hex: 0xE05A55))
                                        .cornerRadius(16)
                                        .padding(.top, 44)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .disabled(viewModel.isUploading)
                                .id("uploadButton")
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
        .onDisappear {
            UITabBar.appearance().isHidden = false
        }
    }
}

#Preview {
    NavigationView {
        NewPostView(
            tabIndex: .constant(0),
            isTabBarHidden: .constant(false),
            editedImage: UIImage(systemName: "photo") ?? UIImage(),
            onReset: {}
        )
    }
}
