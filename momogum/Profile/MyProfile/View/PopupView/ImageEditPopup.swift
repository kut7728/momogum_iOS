//
//  ImageEditPopup.swift
//  momogum
//
//  Created by 류한비 on 1/25/25.
//

import SwiftUI

struct ImageEditPopup: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var navigationPath: NavigationPath
    @Binding var showPopup: Bool

    var body: some View {
        VStack {
            // 기본 이미지 사용
            Button {
                DispatchQueue.main.async {
                    viewModel.setDefaultImage()
                    showPopup = false
                }
            } label: {
                Text("기본 이미지 사용")
                    .font(.mmg(.subheader4))
                    .foregroundColor(Color.black_2)
            }
            .padding(.bottom, 14)

            Divider().frame(width: 160)

            // 갤러리에서 선택
            Button {
                DispatchQueue.main.async {
                    navigationPath.append("GalleryProfileView")
                    showPopup = false
                }
            } label: {
                Text("갤러리에서 선택")
                    .font(.mmg(.subheader4))
                    .foregroundColor(Color.black_2)
            }
            .padding(.top, 14)
        }
        .frame(width: 207, height: 127)
        .background(Color.black_6)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black_4, lineWidth: 1)
        )
    }
}
