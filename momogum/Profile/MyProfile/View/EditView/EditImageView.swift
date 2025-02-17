//
//  EditImageView.swift
//  momogum
//
//  Created by 류한비 on 1/24/25.
//

import UIKit
import SwiftUI

struct EditImageView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var profileViewModel: ProfileViewModel
    @StateObject private var viewModel: ImageEditorViewModel
    var selectedImage: UIImage?
    
    init(
        selectedImage: UIImage?,
        navigationPath: Binding<NavigationPath>,
        profileViewModel: ProfileViewModel
    ) {
        let defaultImage = UIImage()
        let imageToUse = selectedImage ?? defaultImage
        _viewModel = StateObject(wrappedValue: ImageEditorViewModel(image: imageToUse))
        _navigationPath = navigationPath
        self._profileViewModel = ObservedObject(initialValue: profileViewModel)
        self.selectedImage = imageToUse
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let frameSize = screenWidth
                
                ZStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
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
                }
                .frame(width: frameSize, height: frameSize)
                .clipped()
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                VStack {
                    HStack {
                        // back 버튼
                        Button {
                            navigationPath.removeLast(1)
                        } label: {
                            Image("back")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .padding(.trailing, 300)
                        
                        // cancel 버튼
                        Button {
                            DispatchQueue.main.async {
                                profileViewModel.resetUserData()
                                navigationPath.removeLast(2)
                            }
                        } label: {
                            Image("close")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding(.horizontal, 30)
                    .frame(height: 40)
                    
                    Spacer()
                    
                    // 다음 버튼
                    HStack {
                        Spacer()
                        Button {
                            if let finalizeImage = viewModel.finalizeImage(frameSize: frameSize) {
                                DispatchQueue.main.async {
                                    profileViewModel.convertPreviewImage(from: finalizeImage)
                                    navigationPath.removeLast(2)
                                }
                            }
                        } label: {
                            Rectangle()
                                .frame(width: 105, height: 52)
                                .foregroundStyle(Color.Red_2)
                                .cornerRadius(12)
                                .overlay(
                                    Text("다음")
                                        .font(.mmg(.subheader3))
                                        .foregroundStyle(Color.black_6)
                                )
                        }
                    }
                    .padding(.trailing, 39)
                    .padding(.bottom, 30)
                }
            }
            
            Circle()
                .stroke(lineWidth: 2)
                .foregroundStyle(Color.Red_2)
                .frame(width: 360, height: 360)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
    }
}
