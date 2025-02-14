//
//  GalleryPickerView.swift
//  momogum
//
//  Created by 조승연 on 1/17/25.
//

import SwiftUI

struct GalleryPickerView: View {
    @StateObject private var viewModel = GalleryPickerViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Binding var tabIndex: Int
    @Binding var isTabBarHidden: Bool

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let gridItems = [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ]
                let gridItemSize = (geometry.size.width - 48) / 3

                ZStack(alignment: .top) {
                    if viewModel.isPermissionGranted {
                        ScrollView {
                            LazyVGrid(columns: gridItems, spacing: 8) {
                                ForEach(viewModel.images.indices, id: \.self) { index in
                                    if let image = viewModel.images[index] {
                                        NavigationLink(
                                            destination: ImageEditorView(image: image, tabIndex: $tabIndex, isTabBarHidden: $isTabBarHidden)
                                                .navigationBarBackButtonHidden(true)
                                                .navigationBarHidden(true)
                                        ) {
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

                                    // 🚀 스크롤이 끝에 도달하면 추가 로드!
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
                        Text("사진 권한이 필요합니다. 설정에서 권한을 허용해주세요.")
                            .multilineTextAlignment(.center)
                            .padding()
                    }

                    VStack {
                        HStack {
                            Button(action: {
                                isTabBarHidden = false
                                tabIndex = 0
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .font(.title2)
                            }
                            .frame(width: 44, height: 44)

                            Text("사진 선택")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.leading, -50)
                                .frame(maxWidth: .infinity, alignment: .center)

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 60)
                        .background(Color.white)

                        Spacer()
                    }
                }
                .onAppear {
                    isTabBarHidden = true
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
    }
}

#Preview {
    GalleryPickerView(tabIndex: .constant(1), isTabBarHidden: .constant(false))
}
