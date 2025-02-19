//
//  EditProfileView.swift
//  momogum
//
//  Created by 류한비 on 1/19/25.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var viewModel: ProfileViewModel
    
    // 팝업창
    @State private var showPopup = false

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                // NavigationBar
                EditNavigationBar()

                // 프로필 이미지
                ProfileImage()

                // 유저 정보 편집
                EditUserData()
            }
            .edgesIgnoringSafeArea(.all)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden()
            .disabled(showPopup)

            // Popup
            ShowPopup()
        }
    }
}

// MARK: - Private Extension
private extension EditProfileView {

    // NavigationBar
    private func EditNavigationBar() -> some View {
        HStack(alignment: .center, spacing: 0) {
            // back 버튼
            Button {
                viewModel.resetUserData() // 임시 이미지 초기화
                navigationPath.removeLast(1)
            } label: {
                Image("back")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .padding(.trailing, 104)
            .padding(.leading, 40)

            Text("프로필 편집")
                .font(.mmg(.subheader3))
                .foregroundColor(.black)

            Spacer()
        }
        .padding(.top, 82)
        .padding(.trailing, 32)
    }

    // 프로필 이미지
    private func ProfileImage() -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            if let profileImage = viewModel.currentPreviewImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 88)
                    .clipShape(Circle())
                    .padding(3)
            } else {
                Image("defaultProfile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 88)
                    .clipShape(Circle())
                    .padding(3)
            }

            // 수정 버튼
            Image("pencil")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.bottom, 5)
        }
        .padding(.top, UIScreen.main.bounds.height <= 812 ? 30 : 75)
        .onTapGesture {
            if viewModel.isDefaultProfileImage {
                navigationPath.append("GalleryProfileView")
            } else {
                showPopup = true
            }
        }
        .onAppear {
            KeyboardHider.hideKeyboard()
        }
    }

    // 유저 정보 편집
    private func EditUserData() -> some View {
        VStack(alignment: .center, spacing: 0) {
            // 이름 수정
            EditableField(label: "이름", value: viewModel.userName, destination: "EditNameView")

            // 아이디 수정
            EditableField(label: "사용자 아이디", value: viewModel.userID, destination: "EditIDView")

            // 한 줄 소개 수정
            VStack(alignment: .leading, spacing: 0) {
                Text("한 줄 소개")
                    .font(.mmg(.subheader4))
                    .padding(.bottom, 31)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black_5)
                        .frame(width: 320, height: 126)

                    TextEditor(text: .constant(viewModel.userBio))
                        .scrollContentBackground(.hidden)
                        .padding(10)
                        .frame(width: 320, height: 126)
                        .font(.mmg(.Body3))
                        .background(Color.clear)
                        .disabled(true)

                    if viewModel.userBio.isEmpty {
                        Text("소개를 입력하세요")
                            .font(.mmg(.Body3))
                            .foregroundStyle(Color.black_3)
                            .padding(.trailing, 178)
                            .padding(.bottom, 70)
                    }

                    Rectangle() // 클릭 감지
                        .frame(width: 320, height: 126)
                        .foregroundStyle(Color.white.opacity(0.001))
                }
                .frame(width: 320, height: 126)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black_4, lineWidth: 1)
                )
            }
            .padding(.horizontal, 47)
            .padding(.bottom, 25)
            .onTapGesture {
                navigationPath.append("EditBioView")
            }

            // 완료버튼
            HStack {
                Spacer()
                Button {
                    if let userId = viewModel.uuid {
                        viewModel.saveUserData(userId: userId)
                        navigationPath.removeLast(1)
                    }
                } label: {
                    Rectangle()
                        .frame(width: 105, height: 52)
                        .foregroundStyle(Color.Red_2)
                        .cornerRadius(12)
                        .overlay(
                            Text("완료")
                                .font(.mmg(.subheader3))
                                .foregroundStyle(Color.black_6)
                        )
                }
            }
            .padding(.horizontal, 48)
            .padding(.bottom, UIScreen.main.bounds.height <= 812 ? 20 : 100)
        }
        .padding(.top, 60)
    }

    // 공통 필드 컴포넌트 (이름 & 아이디)
    private func EditableField(label: String, value: String, destination: String) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.mmg(.subheader4))

            ZStack {
                TextField("\(label)을 입력하세요", text: .constant(value))
                    .frame(width: 328, height: 39)
                    .padding(.leading, 12)
                    .font(.mmg(.Body3))
                    .disabled(true)

                Rectangle() // 클릭 감지
                    .frame(width: 328, height: 30)
                    .foregroundStyle(Color.white.opacity(0.001))
            }

            Rectangle()
                .frame(width: 328, height: 1)
                .foregroundStyle(.black_4)
        }
        .padding(.horizontal, 47)
        .padding(.bottom, 40)
        .onTapGesture {
            navigationPath.append(destination)
        }
    }

    // Popup
    private func ShowPopup() -> some View {
        ZStack {
            if showPopup {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPopup = false // 바깥 영역 터치 시 팝업 비활성화
                    }

                ImageEditPopup(viewModel: viewModel, navigationPath: $navigationPath, showPopup: $showPopup)
                    .padding(.bottom, 200)
            }
        }
    }
}
