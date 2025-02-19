//
//  EditBioView.swift
//  momogum
//
//  Created by 류한비 on 1/31/25.
//

import SwiftUI

struct EditBioView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var viewModel: ProfileViewModel
    @StateObject private var keyboardObservers = KeyboardObservers(offset: UIScreen.main.bounds.height <= 896 ? 110 : 90)

    private let maxLength = 40

    // 편집 중인 한줄소개
    @State private var draftBio: String = ""

    init(navigationPath: Binding<NavigationPath>, viewModel: ProfileViewModel) {
        self._navigationPath = navigationPath
        self._viewModel = ObservedObject(initialValue: viewModel)
        self._draftBio = State(initialValue: viewModel.userBio)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0){
            // NavigationBar
            EditNavigationBar()

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
            draftBio = ""
        }
    }
}

//MARK: -  extension
private extension EditBioView {

    // NavigationBar
    private func EditNavigationBar() -> some View {
        HStack(alignment: .center) {
            // Back 버튼
            Button {
                navigationPath.removeLast(1) // 취소 시 돌아가기
            } label: {
                Image("close_s")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.trailing, UIScreen.main.bounds.height <= 812 ? 92 : 105)
            .padding(.leading, 28)

            Text("한줄소개")
                .font(.mmg(.subheader3))
                .foregroundColor(.black)

            Spacer()
        }
        .padding(.top, 77)
        .padding(.trailing, 32)
        .padding(.bottom, 182)
    }

    // 편집 TextField
    private func EditTextField() -> some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black_5)
                    .frame(width: 320, height: 126)

                TextEditor(text: $draftBio)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .font(.mmg(.Body3))
                    .frame(width: 320, height: 126)
                    .background(Color.clear)
                    .onChange(of: draftBio) { _, newValue in
                        if newValue.count > maxLength {
                            draftBio = String(newValue.prefix(maxLength)) // 초과 글자 제거
                        }
                    }
            }
            .frame(width: 320, height: 126)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black_4, lineWidth: 1)
            )

            Text("\(draftBio.count) / \(maxLength)")
                .font(.mmg(.Caption3))
                .foregroundStyle(Color.black_2)
                .padding(.leading, 262)
                .padding(.top, 16)
        }
        .padding(.horizontal, 37)
    }

    // 완료 버튼
    private func CompletedButton() -> some View {
        HStack(spacing: 0) {
            Spacer()
            Button {
                viewModel.userBio = draftBio
                navigationPath.removeLast(1)
            } label: {
                Text("완료")
                    .font(.mmg(.subheader3))
                    .foregroundStyle(draftBio.isEmpty ? Color.black_4 : Color.Red_2)
            }
            .disabled(draftBio.isEmpty)
        }
        .padding(.trailing, 62.5)
        .padding(.bottom, keyboardObservers.keyboardHeight > 0 ? keyboardObservers.keyboardHeight : 116)
        .animation(.easeInOut(duration: 0.3), value: keyboardObservers.keyboardHeight)
    }
}
