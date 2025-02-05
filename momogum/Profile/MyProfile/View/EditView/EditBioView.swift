//
//  EditBioView.swift
//  momogum
//
//  Created by 류한비 on 1/31/25.
//

import SwiftUI

struct EditBioView: View {
    @Binding var navigationPath: NavigationPath
    @Bindable var viewModel: ProfileViewModel
    @State private var keyboardHeight: CGFloat = 0
    
    private let maxLength = 40
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            HStack(alignment: .center){
                // back 버튼
                Button{
                    viewModel.resetUserBio()
                    navigationPath.removeLast(1)
                } label: {
                    Image("close_s")
                        .resizable()
                        .frame(width: 24,height: 24)
                }
                .padding(.trailing,UIScreen.main.bounds.height <= 812 ? 92 : 105)
                .padding(.leading, 28)
                
                Text("한줄소개")
                    .font(.mmg(.subheader3))
                    .foregroundColor(.black)
                
                Spacer()
                
            }
            .padding(.top, 77)
            .padding(.trailing, 32)
            .padding(.bottom, 182)
            
            VStack(alignment: .center, spacing: 0){
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black_5)
                        .frame(width: 320, height: 126)
                    
                    TextEditor(text: $viewModel.draftUserBio)
                        .scrollContentBackground(.hidden)
                        .padding(10)
                        .font(.mmg(.Body3))
                        .frame(width: 320, height: 126)
                        .background(Color.clear)
                        .onChange(of: viewModel.draftUserBio) { _, newValue in
                            if newValue.count > maxLength {
                                viewModel.draftUserBio = String(newValue.prefix(maxLength)) // 초과 글자 제거
                            }
                        }
                }
                .frame(width: 320, height: 126)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black_4, lineWidth: 1)
                )
                
                Text("\(viewModel.draftUserBio.count) / 40")
                    .font(.mmg(.Caption3))
                    .foregroundStyle(Color.black_2)
                    .padding(.leading, 262)
                    .padding(.top, 16)
                
            }
            .padding(.horizontal, 37)
            .onAppear {
                viewModel.draftUserBio = ""
            }
            
            Spacer()
            
            HStack(spacing: 0){
                Spacer()
                Button{
                    navigationPath.removeLast(1)
                }label:{
                    Text("완료")
                        .font(.mmg(.subheader3))
                        .foregroundStyle(viewModel.draftUserBio.count != 0 ? Color.Red_2 : Color.black_4)
                }
            }
            .padding(.trailing, 62.5)
            .padding(.bottom, keyboardHeight > 0 ? keyboardHeight : 116) // 키보드 높이만큼 올리기
            .animation(.easeInOut(duration: 0.3), value: keyboardHeight) // 부드럽게 애니메이션 적용
        }
        .edgesIgnoringSafeArea(.all)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .onAppear {
            addKeyboardObservers()
        }
        .onDisappear {
            removeKeyboardObservers()
        }
    }
    
    // MARK: - 키보드 이벤트 감지
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height - 110
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardHeight = 0
        }
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
