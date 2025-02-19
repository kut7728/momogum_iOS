//
//  EditIDView.swift
//  momogum
//
//  Created by 류한비 on 1/31/25.
//

import SwiftUI

struct EditIDView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var viewModel: ProfileViewModel
    @StateObject private var keyboardObservers = KeyboardObservers(offset: UIScreen.main.bounds.height <= 896 ? 100 : 90)

    @State private var showCloseButton = false
    @State private var underBarColor: Color = Color.black_4
    @State private var isIDAvailable = false // 중복확인
    @State private var checkCircle1 = false // 최소 5자 ~ 최대 20자
    @State private var checkCircle2 = false // 영어 소문자, 숫자, 특수문자( “.”, “_”) 사용 가능

    private let maxLength = 20

    // 유저가 입력하는 ID
    @State private var draftID: String = ""

    init(navigationPath: Binding<NavigationPath>, viewModel: ProfileViewModel) {
        self._navigationPath = navigationPath
        self._viewModel = ObservedObject(initialValue: viewModel)
        self._draftID = State(initialValue: viewModel.userID)
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
        .onAppear {
            draftID = ""
        }
    }
}

// MARK: - Private Extension
private extension EditIDView {

    // NavigationBar
    private func EditNavigationBar() -> some View {
        HStack(alignment: .center){
            // Back 버튼
            Button{
                navigationPath.removeLast(1)
            } label: {
                Image("close_s")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.trailing, UIScreen.main.bounds.height <= 812 ? 64 : 77)
            .padding(.leading, 28)

            Text("유저아이디 변경")
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
            Text("변경할 유저아이디를")
                .font(.system(size: 24))
                .fontWeight(.semibold)

            Text("입력해주세요.")
                .font(.system(size: 24))
                .fontWeight(.semibold)
        }
        .padding(.bottom, 72)
        .padding(.trailing, 136)
    }

    // 편집 TextField
    private func EditTextField() -> some View {
        VStack(alignment: .leading, spacing: 0){
            ZStack{
                HStack{
                    TextField("변경할 유저아이디 입력", text: $draftID)
                        .frame(width: 268, height: 39)
                        .font(.mmg(.subheader4))
                        .padding(.leading, 12)
                        .onChange(of: draftID) { _, newValue in
                            validateID(newValue)
                        }
                    Spacer().frame(width: 50, height: 39)
                }

                if showCloseButton {
                    HStack {
                        Spacer().frame(width: 288, height: 39)
                        Button {
                            draftID = ""
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

            if !isIDAvailable {
                VStack(alignment: .leading, spacing: 0){
                    HStack(spacing: 0){
                        Image(checkCircle1 ? "check_circle_green" : "check_circle")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(.trailing, 8)

                        Text("최소 5자 ~ 최대 20자")
                            .font(.mmg(.Caption2))
                            .foregroundStyle(Color.black_3)
                    }
                    .padding(.bottom, 12)

                    HStack(spacing: 0){
                        Image(checkCircle2 ? "check_circle_green" : "check_circle")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(.trailing, 8)

                        Text("영어 소문자, 숫자, 특수문자( “.”, “_”) 사용 가능")
                            .font(.mmg(.Caption2))
                            .foregroundStyle(Color.black_3)
                    }
                }
                .padding(.top, 24)
            }
        }
        .padding(.horizontal, 47)
    }

    // 완료 버튼
    private func CompletedButton() -> some View {
        HStack(spacing: 0){
            Spacer()
            Button {
                if checkCircle1 && checkCircle2 {
                    viewModel.userID = draftID
                    navigationPath.removeLast(1)
                }
            } label: {
                Text("완료")
                    .font(.mmg(.subheader3))
                    .foregroundStyle(
                        checkCircle1 && checkCircle2 ? Color.Red_2 : Color.black_4)
            }
            .disabled(!(checkCircle1 && checkCircle2))
        }
        .padding(.trailing, 62.5)
        .padding(.bottom, keyboardObservers.keyboardHeight > 0 ? keyboardObservers.keyboardHeight - 40 : 116)
        .animation(.easeInOut(duration: 0.3), value: keyboardObservers.keyboardHeight)
    }

    // 유효성 검사 함수
    private func validateID(_ newValue: String) {
        let allowedCharacters = CharacterSet.lowercaseLetters
            .union(.decimalDigits)
            .union(CharacterSet(charactersIn: "._"))

        checkCircle1 = (5...20).contains(newValue.count)
        checkCircle2 = newValue.count >= 5 && newValue.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }

        // 밑줄 색상 변경
        if newValue.count < 5 {
            underBarColor = Color.black_4
        } else if checkCircle1 && checkCircle2 {
            underBarColor = Color.Green_1
        } else {
            underBarColor = Color.Red_1
        }

        showCloseButton = !newValue.isEmpty
    }
}
