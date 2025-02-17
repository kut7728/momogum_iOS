//
//  EditNameView.swift
//  momogum
//
//  Created by 류한비 on 1/31/25.
//

import SwiftUI

struct EditNameView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var viewModel: ProfileViewModel
    @StateObject private var keyboardObservers = KeyboardObservers(offset: 90)

    @State private var showCloseButton = false
    @State private var underBarColor: Color = Color.black_4
    @State private var showErrorMessage = false

    private let maxLength = 12

    // 유저가 입력하는 이름 (초기값: 기존 이름 유지)
    @State private var draftName: String

    init(navigationPath: Binding<NavigationPath>, viewModel: ProfileViewModel) {
        self._navigationPath = navigationPath
        self._viewModel = ObservedObject(initialValue: viewModel)
        self._draftName = State(initialValue: viewModel.userName)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0){
            // NavigationBar
            EditNavigationBar()

            // 안내말
            EditGuide()

            // 편집 TextField
            EditTextField()

            Spacer()

            // 완료 버튼
            CompletedButton()
        }
        .edgesIgnoringSafeArea(.all)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Private Extension
private extension EditNameView {

    // NavigationBar
    private func EditNavigationBar() -> some View {
        HStack(alignment: .center){
            // Back 버튼
            Button{
                navigationPath.removeLast(1) // 취소 시 돌아가기
            } label: {
                Image("close_s")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.trailing, UIScreen.main.bounds.height <= 812 ? 90 : 103)
            .padding(.leading, 28)

            Text("이름 변경")
                .font(.mmg(.subheader3))
                .foregroundColor(.black)

            Spacer()
        }
        .padding(.top, 77)
        .padding(.trailing, 32)
        .padding(.bottom, 102)
    }

    // 안내말
    private func EditGuide() -> some View {
        VStack(alignment: .leading, spacing: 0){
            Text("변경할 이름을 입력해주세요")
                .font(.system(size: 24))
                .fontWeight(.semibold)
                .padding(.bottom, 12)

            Text("12자 이내의 한글, 영문 사용 가능해요:)")
                .font(.system(size: 16))
                .foregroundColor(Color.black_3)
                .padding(.leading, 3)
        }
        .padding(.bottom, 68)
        .padding(.trailing, 74)
    }

    // 편집 TextField
    private func EditTextField() -> some View {
        VStack(alignment: .leading, spacing: 0){
            ZStack {
                HStack {
                    TextField("변경할 이름 입력", text: $draftName)
                        .frame(width: 268, height: 39)
                        .font(.mmg(.subheader4))
                        .padding(.leading, 12)
                        .onChange(of: draftName) { _, newValue in
                            validateName(newValue)
                        }
                    Spacer().frame(width: 50, height: 39)
                }

                if showCloseButton {
                    HStack {
                        Spacer().frame(width: 288, height: 39)
                        Button {
                            draftName = ""
                            showCloseButton = false
                        } label: {
                            Image("close_black3")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }

            Rectangle()
                .frame(width: 328, height: 1)
                .foregroundStyle(underBarColor)
                .padding(.top, 5)

            if showErrorMessage {
                Text("잘못된 입력입니다.")
                    .font(.mmg(.Caption1))
                    .foregroundStyle(Color.Red_1)
                    .padding(.top, 8)
                    .padding(.leading, 11)
            } else {
                Spacer().frame(width: 328, height: 24)
            }
        }
        .padding(.horizontal, 47)
    }

    // 완료 버튼
    private func CompletedButton() -> some View {
        HStack(spacing: 0){
            Spacer()
            Button {
                if !showErrorMessage && !draftName.isEmpty {
                    viewModel.userName = draftName
                    navigationPath.removeLast(1)
                }
            } label: {
                Text("완료")
                    .font(.mmg(.subheader3))
                    .foregroundStyle(
                        !showErrorMessage && !draftName.isEmpty ? Color.Red_2 : Color.black_4)
            }
            .disabled(showErrorMessage || draftName.isEmpty)
        }
        .padding(.trailing, 62.5)
        .padding(.bottom, keyboardObservers.keyboardHeight > 0 ? keyboardObservers.keyboardHeight : 116)
        .animation(.easeInOut(duration: 0.3), value: keyboardObservers.keyboardHeight)
    }

    // 이름 유효성 검사
    private func validateName(_ newValue: String) {
        if newValue.count > maxLength { // 길이 제한
            draftName = String(newValue.prefix(maxLength))
        }

        // 한글 & 영문만 허용 (숫자 및 특수문자 제한)
        let hasInvalidChar = newValue.rangeOfCharacter(from: CharacterSet.letters.union(.whitespaces).inverted) != nil
        showErrorMessage = hasInvalidChar

        // 밑줄 색상 변경
        underBarColor = hasInvalidChar ? Color.Red_1 : Color.black_4
        showCloseButton = !newValue.isEmpty
    }
}
