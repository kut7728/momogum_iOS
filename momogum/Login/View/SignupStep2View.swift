//
//  SignupStep2View.swift
//  momogum
//
//  Created by 서재민 on 1/12/25.
//

import SwiftUI

struct SignupStep2View: View {
    //MARK: - Properties
    @Environment(\.dismiss) var dismiss
//    @Environment(SignupDataModel.self) var signupDataModel
    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool
    @State private var lengthCheck: Bool = false
    @State private var hasAllowedCharactersOnly: Bool = false
    @State private var isDuplicated: Bool = true

    private var isButtonEnabled: Bool {
           return lengthCheck && hasAllowedCharactersOnly
       }
    @Binding var path: [String]

    //MARK: - View
    var body: some View {
        
        //        @Bindable var signupDataModel = signupDataModel
        ZStack (alignment: .bottomTrailing) {
            VStack{
                HStack{
                    Button {
                        path = []
                    }label:{
                        Image(systemName: "xmark")
                    }
                    .foregroundStyle(Color.black)
                    .padding(.leading, 28)
                    .frame(width: 24, height: 24)
                    
                    Text("정보 입력")
                        .font(.system(size:20))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity,alignment: .top)
                        .padding(.leading, 107)
                        .padding(.trailing,159)
                        .padding(.bottom,5)
                }
                
                
                
                
                VStack{
                    HStack(spacing: 3){
                        Text("STEP 2")
                            .font(.system(size:16))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.momogumRed)
                        
                        Text("/ 2")
                            .font(.system(size:16))
                            .fontWeight(.regular)
                            .foregroundStyle(Color.gray)
                    }
                    .padding(.top,43)
                    .padding(.leading,38)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Text("머머금에서 사용할 아이디를 입력해주세요")
                        .padding(.top,39)
                        .fontWeight(.semibold)
                        .font(.system(size:24))
                        .padding(.leading,43)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    VStack{
                        
                        HStack{
                            
                            TextField("머머금", text: $inputText /*$signupDataModel.nickname*/ ,onEditingChanged: { editing in
                                if editing {
                                    isFocused = true
                                }
                            })
                            .modifier(SignupTextfieldModifer())
                            .focused($isFocused)
                            .foregroundStyle(isFocused ? Color.black : Color.signupDescriptionGray)
                            .onChange(of: inputText /*signupDataModel.nickname*/) { _ , newValue in
                                validateInput2(newValue)
                            }
                            
                            
                            Button{
                                //                            print(signupDataModel.creatUser())
                                if !isDuplicated{
                                    isDuplicated = true
                                    
                                }
                                
                            }label:{
                                Text("중복확인")
                            }
                            .fontWeight(.semibold)
                            .foregroundStyle(isButtonEnabled ? Color.Red_2 : Color.signupDescriptionGray)
                            .disabled(!isButtonEnabled)
                            .disabled(isDuplicated)
                            .padding(.top,142)
                            .padding(.trailing,32)
                        }
                        // Divider의 색상을 TextField 상태에 따라 변경
                        Divider()
                            .frame(height: 2)
//                            .background(isFocused ? Color.black : Color.placeholderGray2)
                            .background{
                                if isFocused{
                                    Color.black
                                    if isButtonEnabled{
                                        Color.green
                                    }
                                    else if lengthCheck && !hasAllowedCharactersOnly{
                                        Color.Red_2
                                    }
                                    
                                }
                                else {
                                    Color.placeholderGray2
                                }
                            }
                            .padding(.horizontal,32)
                        
                        
                        VStack{
                            if isButtonEnabled{
                                Text("사용 가능한 아이디입니다:)")
                                    .font(.system(size:16))
                                    .fontWeight(.regular)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading,34)
                                    .foregroundStyle(Color.green)
                            }
                            else {
                                validationText("최소 5자~ 20자",isValid: lengthCheck)
                                    .font(.system(size:16))
                                    .fontWeight(.regular)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading,34)
                                
                                validationText("영어소문자,숫자,'.','_'사용가능", isValid: hasAllowedCharactersOnly)
                                    .font(.system(size:16))
                                    .fontWeight(.regular)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading,34)
                            }

                         
                        }
                     
                    }
                    Spacer()
                    HStack{
                        Button{
                            dismiss()
                        } label:{
                            Text("이전단계")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 93)
                        .padding(.leading, 43)
                        .foregroundStyle(Color.placeholderGray)
                        NavigationLink{
                            MainTabView()
                        }label: {
                            Text("완료")
                                .disabled(!isButtonEnabled)
                            //+백엔드 중복확인 api값
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundStyle(.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.trailing, 47)
                        .padding(.bottom, 93)
                    }
                }
                .navigationBarBackButtonHidden()
                
            }
            .ignoresSafeArea(.keyboard)
        }
        .onAppear {
            KeyboardHider.hideKeyboard()
        }
    }
    
    //MARK: - Function
    //리팩토링할때 옮기겠습니다
    func validateInput2(_ text: String) {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789._")
        lengthCheck = text.count >= 5 &&
                         text.count <= 20 &&
                         text.range(of: "[a-z]", options: .regularExpression) != nil
        hasAllowedCharactersOnly = text.unicodeScalars.allSatisfy { allowedCharacters.contains($0) } &&  text.range(of: "[a-z]", options: .regularExpression) != nil
    }
}
    @ViewBuilder
    func validationText(_ text: String, isValid: Bool) -> some View {
        HStack {
            Image(systemName:"checkmark.circle" )
                .foregroundColor(isValid ? .green : .signupDescriptionGray)
            Text(text)
                .foregroundColor(isValid ? .green : .signupDescriptionGray)
        }
    }



#Preview {
    SignupStep2View(path: .constant([]))
}
