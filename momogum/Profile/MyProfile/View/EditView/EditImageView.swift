import UIKit
import SwiftUI

struct EditImageView: View {
    @Binding var navigationPath: NavigationPath
    @Bindable var viewModel: ProfileViewModel
    @State private var scale: CGFloat = 1.0 // 줌 배율
    @State private var offset: CGSize = .zero // 이미지 이동 거리
    @State private var lastOffset: CGSize = .zero // 마지막 드래그 위치 저장
    
    @State private var imageFrame: CGRect = .zero // 이미지의 실제 프레임 저장
    @State private var overlayFrame: CGRect = .zero // 원형 오버레이의 프레임 저장
    
    var body: some View {
        VStack(spacing : 0){
            HStack(spacing : 0){
                // back 버튼
                Button{
                    navigationPath.removeLast(1)
                } label: {
                    Image("back")
                        .resizable()
                        .frame(width: 24,height: 24)
                }
                .padding(.trailing, 320)
                
                // cancel 버튼
                Button{
                    viewModel.resetUserData()
                    navigationPath.removeLast(2)
                } label: {
                    Image("close")
                        .resizable()
                        .frame(width: 20,height: 20)
                }
            }
            .padding(.top, 68)
            .padding(.bottom, 136)
            
            if let uiImage = viewModel.currentPreviewImage {
                ZStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 394, height: 394)
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.3)) {
                                        scale = min(1.5, max(1.0, value))
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        if scale < 1.0 { scale = 1.0 }
                                    }
                                }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newOffset = CGSize(
                                        width: lastOffset.width + value.translation.width * 1.0,
                                        height: lastOffset.height + value.translation.height * 1.0
                                    )
                                    offset = newOffset
                                }
                                .onEnded { _ in
                                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                        offset.width = min(max(offset.width, -100), 100)
                                        offset.height = min(max(offset.height, -50), 50)
                                        lastOffset = offset
                                    }
                                }
                        )
                        .background(GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    imageFrame = geometry.frame(in: .global)
                                }
                        })
                    
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(Color.Red_2)
                        .frame(width: 360, height: 360)
                        .background(GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    overlayFrame = geometry.frame(in: .global)
                                }
                        })
                }
            } else {
                Text("이미지를 불러올 수 없습니다.")
            }
            
            HStack {
                Spacer()
                Button {
                    cropAndSaveImage()
                    navigationPath.removeLast(2)
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
            .padding(.top, 130)
            .padding(.trailing, 29)
            .padding(.bottom, 63)
        }
        .edgesIgnoringSafeArea(.all)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
    }
    
    // 현재 화면에서 보이는 이미지의 특정 원 영역을 크롭하여 저장
    private func cropAndSaveImage() {
        guard let uiImage = viewModel.currentPreviewImage else {
            return
        }
        
        let originalSize = uiImage.size
        let screenWidth: CGFloat = 394
        let scaleFactor = originalSize.width / screenWidth
        
        let scaledOverlaySize = 360 / scale
        let scaledX = (-offset.width / scale + (screenWidth - scaledOverlaySize) / 2) * scaleFactor
        let scaledY = (-offset.height / scale + (screenWidth - scaledOverlaySize) / 2) * scaleFactor
        let scaledWidth = scaledOverlaySize * scaleFactor
        let scaledHeight = scaledOverlaySize * scaleFactor
        
        let cropRect = CGRect(
            x: max(0, scaledX),
            y: max(0, scaledY),
            width: min(originalSize.width, scaledWidth),
            height: min(originalSize.height, scaledHeight)
        )
        
        if let croppedImage = cropImage(uiImage, to: cropRect) {
            DispatchQueue.main.async {
                viewModel.convertPreviewImage(from: croppedImage)
            }
        }
    }
    
    
    
    // 이미지 크롭 함수
    private func cropImage(_ image: UIImage, to rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
