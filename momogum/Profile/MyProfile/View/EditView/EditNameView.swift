//
//  EditNameView.swift
//  momogum
//
//  Created by 류한비 on 1/31/25.
//

import SwiftUI

struct EditNameView: View {
    @Binding var navigationPath: NavigationPath
    @Bindable var viewModel: ProfileViewModel
    
    @State private var showCloseButton = false
    @State private var underBarColor: Color = Color.black_4
    @State private var showerrorMessage = false
    @State private var keyboardHeight: CGFloat = 0
    
    private let maxLength = 12
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            HStack(alignment: .center){
                // back 버튼
                Button{
                    viewModel.resetUserName()
                    navigationPath.removeLast(1)
                } label: {
                    Image("close_s")
                        .resizable()
                        .frame(width: 24,height: 24)
                }
                .padding(.trailing,UIScreen.main.bounds.height <= 812 ? 90 : 103)
                .padding(.leading, 28)
                
                Text("이름 변경")
                    .font(.mmg(.subheader3))
                    .foregroundColor(.black)
                
                Spacer()
                
            }
            .padding(.top, 77)
            .padding(.trailing, 32)
            .padding(.bottom, 102)
            
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
            
            VStack(alignment: .leading, spacing: 0){
                ZStack {
                    HStack {
                        TextField("변경할 이름 입력", text: $viewModel.draftUserName)
                            .frame(width: 268, height: 39)
                            .font(.mmg(.subheader4))
                            .padding(.leading, 12)
                            .onChange(of: viewModel.draftUserName) { _, newValue in
                                if newValue.count > maxLength { // 길이 제한
                                    viewModel.draftUserName = String(newValue.prefix(maxLength))
                                }
                                
                                // 숫자 및 특수문자 입력 제한
                                let hasInvalidChar = newValue.rangeOfCharacter(from: CharacterSet.letters.union(.whitespaces).inverted) != nil
                                if hasInvalidChar {
                                    underBarColor = Color.Red_1
                                    showerrorMessage = true
                                } else {
                                    underBarColor = Color.black_4
                                    showerrorMessage = false
                                }
                                
                                showCloseButton = !newValue.isEmpty
                            }
                        Spacer().frame(width: 50, height: 39)
                    }
                    
                    if showCloseButton {
                        HStack{
                            Spacer().frame(width: 288, height: 39)
                            Button{
                                viewModel.draftUserName = ""
                                showCloseButton = false
                            }label:{
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
                
                if showerrorMessage {
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
            .onAppear {
                viewModel.draftUserName = ""
            }
            
            Spacer()
            
            HStack(spacing: 0){
                Spacer()
                Button{
                    if (viewModel.draftUserName.count <= maxLength) &&
                        (showerrorMessage == false) &&
                        (viewModel.draftUserName.count != 0) {
                        navigationPath.removeLast(1)
                    }
                }label:{
                    Text("완료")
                        .font(.mmg(.subheader3))
                        .foregroundStyle((viewModel.draftUserName.count <= maxLength) && (showerrorMessage == false) && (viewModel.draftUserName.count != 0) ? Color.Red_2 : Color.black_4)
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
            KeyboardHider.hideKeyboard()
        }
        .onDisappear {
            removeKeyboardObservers()
        }
    }
    
    // MARK: - 키보드 이벤트 감지
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height - 90
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
