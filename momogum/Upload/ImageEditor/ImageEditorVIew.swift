//
//  ImageEditorView.swift
//  momogum
//
//  Created by 조승연 on 1/22/25.
//

import SwiftUI

struct ImageEditorView: View {
    @StateObject private var viewModel: ImageEditorViewModel
    @Binding var isTabBarHidden: Bool
    @Binding var tabIndex: Int
    @Environment(\.dismiss) var dismiss
    @State private var navigateToNewPost = false
    @State private var editedUIImage: UIImage? = nil

    init(image: UIImage, tabIndex: Binding<Int>, isTabBarHidden: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ImageEditorViewModel(image: image))
        _tabIndex = tabIndex
        _isTabBarHidden = isTabBarHidden
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                GeometryReader { geometry in
                    let screenWidth = geometry.size.width
                    let frameSize = screenWidth

                    ZStack {
                        Image(uiImage: viewModel.image)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: frameSize * viewModel.scale,
                                height: frameSize * viewModel.scale / viewModel.image.size.width * viewModel.image.size.height
                            )
                            .clipped()
                            .offset(viewModel.offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        viewModel.updateOffset(gesture.translation, frameSize: frameSize)
                                    }
                            )
                            .simultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        viewModel.updateScale(viewModel.scale * value, frameSize: frameSize)
                                    }
                            )
                    }
                    .frame(width: frameSize, height: frameSize)
                    .clipped()
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                    VStack {
                        HStack {
                            Button(action: {
                                isTabBarHidden = true
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .font(.title2)
                            }
                            .frame(width: 44, height: 44)

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
                                viewModel.resetToOriginalImage()
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .font(.title2)
                            }
                            .frame(width: 44, height: 44)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 60)

                        Spacer()

                        Button(action: {
                            if let finalizedImage = viewModel.finalizeImage(frameSize: frameSize) {
                                editedUIImage = finalizedImage
                                navigateToNewPost = true
                            }
                        }) {
                            Text("다음")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 100)
                                .background(Color.Red_2)
                                .cornerRadius(8)
                        }
                        .padding(.bottom, 32)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 24)
                    }
                    .zIndex(1)
                }
            }
            .navigationDestination(isPresented: $navigateToNewPost) {  
                if let editedUIImage = editedUIImage {
                    NewPostView(
                        tabIndex: $tabIndex,
                        isTabBarHidden: .constant(false),
                        editedImage: editedUIImage,
                        onReset: { viewModel.resetToOriginalImage() }
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}
