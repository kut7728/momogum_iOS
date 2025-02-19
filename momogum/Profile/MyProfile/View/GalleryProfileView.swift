//
//  GalleryProfileView.swift
//  momogum
//
//  Created by 류한비 on 1/24/25.
//

import SwiftUI
import PhotosUI

struct GalleryProfileView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var profileViewModel: ProfileViewModel
    @StateObject private var viewModel = GalleryPickerViewModel()

    @State private var selectedImage: UIImage? // 선택된 이미지를 저장할 변수

    var body: some View {
        VStack {
            GeometryReader { geometry in
                let gridItems = [
                    GridItem(.flexible(), spacing: 4),
                    GridItem(.flexible(), spacing: 4),
                    GridItem(.flexible(), spacing: 4)
                ]
                let gridItemSize = (geometry.size.width - 48) / 3

                ZStack(alignment: .top) {
                    if viewModel.isPermissionGranted {
                        ScrollView {
                            LazyVGrid(columns: gridItems, spacing: 4) {
                                ForEach(viewModel.images.indices, id: \.self) { index in
                                    if let image = viewModel.images[index] {
                                        Button {
                                            selectedImage = image
                                            navigationPath.append(image)
                                        } label: {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: gridItemSize, height: gridItemSize)
                                                .clipped()
                                        }
                                    } else {
                                        Color.gray
                                            .frame(width: gridItemSize, height: gridItemSize)
                                            .onAppear {
                                                viewModel.loadImage(at: index)
                                            }
                                    }

                                    if index == viewModel.images.count - 1 {
                                        ProgressView()
                                            .onAppear {
                                                viewModel.loadMoreContent()
                                            }
                                    }
                                }
                            }
                            .padding(.top, 80)
                            .padding(.horizontal, 16)
                        }
                    } else {
                        PermissionAlert()
                    }

                    // 상단 네비게이션 바
                    GalleryNavigationBar()
                }
                .onAppear {
                    viewModel.requestPhotoLibraryPermission()
                }
                .alert(isPresented: $viewModel.showPermissionAlert) {
                    Alert(
                        title: Text("권한 필요"),
                        message: Text("사진 라이브러리에 접근하려면 권한이 필요합니다."),
                        primaryButton: .default(Text("설정으로 이동"), action: {
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL)
                            }
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(for: UIImage.self) { image in
            EditImageView(selectedImage: image, navigationPath: $navigationPath, profileViewModel: profileViewModel)
        }
    }
}

// MARK: - Private Extensions
private extension GalleryProfileView {

    // 네비게이션 바
    private func GalleryNavigationBar() -> some View {
        VStack {
            HStack {
                Button(action: {
                    profileViewModel.resetUserData()
                    navigationPath.removeLast(1)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title2)
                }
                .frame(width: 44, height: 44)

                Spacer()
                
                Text("갤러리에서 선택")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()
                Spacer().frame(width: 44, height: 44)
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            .background(Color.white)

            Spacer()
        }
    }

    // 사진 권한 필요 시 알림 메시지
    private func PermissionAlert() -> some View {
        VStack {
            Text("사진 권한이 필요합니다. 설정에서 권한을 허용해주세요.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
