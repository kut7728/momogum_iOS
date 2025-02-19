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
    @ObservedObject var authViewModel = AuthViewModel(signupData: SignupDataModel())
    
    @StateObject private var keyboardObservers = KeyboardObservers(offset: UIScreen.main.bounds.height <= 896 ? 100 : 90)
    @State private var showCloseButton = false
    @State private var underBarColor: Color = Color.black_4
    @State private var isIDAvailable: Bool? = nil // 중복 확인 상태 (nil: 미확인, true: 사용 가능, false: 중복)
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
            EditNavigationBar()
            EditGuide()
            EditTextField()
            Spacer()
            CompletedButton()
        }
        .edgesIgnoringSafeArea(.all)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .onAppear {
            draftID = ""
        }
        .onChange(of: draftID) { _, newValue in
            validateID(newValue)
            isIDAvailable = nil
        }
    }
}

// MARK: - Private Extension
private extension EditIDView {
    private func EditNavigationBar() -> some View {
        HStack(alignment: .center){
            Button{ navigationPath.removeLast(1) } label: {
                Image("close_s").resizable().frame(width: 24, height: 24)
            }
            .padding(.leading, 28)
            .padding(.trailing, UIScreen.main.bounds.height <= 812 ? 64 : 77)
            
            Text("유저아이디 변경").font(.mmg(.subheader3)).foregroundColor(.black)
            Spacer()
        }
        .padding(.top, 77)
        .padding(.trailing, 32)
        .padding(.bottom, 102)
    }
    
    private func EditGuide() -> some View {
        VStack(alignment: .leading, spacing: 0){
            Text("변경할 유저아이디를").font(.system(size: 24)).fontWeight(.semibold)
            Text("입력해주세요.").font(.system(size: 24)).fontWeight(.semibold)
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
            
            // 닉네임 중복 확인이 완료되면 유효성 검사 텍스트 숨김
            if isIDAvailable == nil {
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
            
            // 닉네임 중복 여부 메시지 표시
            if let isAvailable = isIDAvailable {
                Text(isAvailable ? "사용 가능한 아이디입니다 :)" : "이미 사용 중인 아이디입니다.")
                    .font(.mmg(.Caption2))
                    .foregroundColor(isAvailable ? .Green_1 : .Red_1)
                    .padding(.top, 5)
            }
        }
        .padding(.horizontal, 47)
    }
    
    // 완료 버튼 (중복 확인 버튼으로 변경)
    private func CompletedButton() -> some View {
        HStack(spacing: 0){
            Spacer()
            Button {
                if isIDAvailable == true {
                    viewModel.userID = draftID
                    navigationPath.removeLast(1)
                } else {
                    checkIDAvailability()
                }
            } label: {
                Text(isIDAvailable == true ? "완료" : "중복확인")
                    .font(.mmg(.subheader3))
                    .foregroundStyle(
                        (checkCircle1 && checkCircle2) ? Color.Red_2 : Color.black_4
                    )
            }
            .disabled(!(checkCircle1 && checkCircle2))
        }
        .padding(.trailing, 62.5)
        .padding(.bottom, keyboardObservers.keyboardHeight > 0 ? keyboardObservers.keyboardHeight - 10 : 116)
        .animation(.easeInOut(duration: 0.3), value: keyboardObservers.keyboardHeight)
    }

    
    
    
    // 닉네임 중복 확인 요청
    private func checkIDAvailability() {
        guard !draftID.isEmpty else {
            isIDAvailable = nil
            return
        }

        authViewModel.signupData.nickname = draftID
        authViewModel.checkUsernameisDuplicated()

        // 서버 응답을 기반으로 상태 업데이트
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if authViewModel.isUsernameDuplicated == true {
                isIDAvailable = false
                underBarColor = Color.Red_1
            } else {
                isIDAvailable = true
                underBarColor = Color.Green_1
            }
        }
    }

    // 유효성 검사
    private func validateID(_ newValue: String) {
        let allowedCharacters = CharacterSet.lowercaseLetters
            .union(.decimalDigits)
            .union(CharacterSet(charactersIn: "._"))
        
        checkCircle1 = (5...20).contains(newValue.count)
        checkCircle2 = newValue.count >= 5 && newValue.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }
        
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
