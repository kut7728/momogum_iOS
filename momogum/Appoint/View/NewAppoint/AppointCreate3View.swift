//
//  AppointCreate3View.swift
//  momogum
//
//  Created by nelime on 1/20/25.
//

import SwiftUI

/// 약속생성의 3단계, 모임이름(appointName), 식사메뉴(menuName), 식사일정(pickedDate), 식사장소(placeName), 특별소식(note) 적는 뷰
struct AppointCreate3View: View {
    @Environment(NewAppointViewModel.self) var appointViewModel
    @Binding var path: [String]
    
    @State var menuShowing: Bool = false
    @State var dateShowing: Bool = false
    @State var placeShowing: Bool = false
    @State var noteShowing: Bool = false
    @State var buttonShowing: Bool = false
    
    var body: some View {
        @Bindable var viewModel = appointViewModel
        
        ApmBackgroundView(path: $path) {
            ScrollView {
                VStack (spacing: 40) {
                    VStack {
                        Text("식사 모임 이름을 알려주세요.")
                            .font(.mmg(.subheader3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 20)
                        
                        
                        TextField("ex. 더술 출발, 돈까스 먹방", text: $viewModel.appointName)
                            .modifier(ApmTextFieldModifier())
                            .onSubmit {
                                withAnimation {
                                    menuShowing = true
                                }
                            }
                    }
                    
                    
                    if (menuShowing) {
                        VStack (spacing: 0) {
                            Text("식사 메뉴를 알려주세요.")
                                .font(.mmg(.subheader3))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 20)

                            
                            TextField("ex. 더술 닭한마리, 투파피 파스타", text: $viewModel.menuName)
                                .modifier(ApmTextFieldModifier())
                                .onSubmit {
                                    withAnimation {
                                        dateShowing = true
                                    }
                                }
                        }
                        
                    }
                    
                    if (dateShowing) {
                        VStack (spacing: 20) {
                            Text("식사 일정을 알려주세요.")
                                .font(.mmg(.subheader3))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            DatePicker("", selection: $viewModel.pickedDate)
                                .frame(maxWidth: .infinity)
                                .labelsHidden()
                                .datePickerStyle(.wheel)
                                .environment(\.locale, Locale(identifier: String(Locale.preferredLanguages[0])))
                                .background(.black_5)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .onAppear {
                                    withAnimation {
                                        placeShowing = true
                                    }
                                }
                            
                        }
                    }
                    
                    if (placeShowing) {
                        VStack (spacing: 0) {
                            Text("어디서 만날까요?")
                                .font(.mmg(.subheader3))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 20)

                            
                            TextField("ex. 중앙동 다이소 앞, 학교 쪽문 앞", text: $viewModel.placeName)
                                .modifier(ApmTextFieldModifier())
                                .onSubmit {
                                    withAnimation {
                                        noteShowing = true
                                    }
                                }
                        }
                        
                    }
                    
                    if (noteShowing) {
                        VStack (spacing: 0) {
                            Text("특별한 소식이 있나요?")
                                .font(.mmg(.subheader3))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 20)

                            
                            TextField("ex. 꾸밈단계 2단계", text: $viewModel.note)
                                .modifier(ApmTextFieldModifier())
                        }
                        .padding(.bottom, 60)
                    }
                    
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 50)
            }
            
            
            /// 다음 호버 버튼
            if (noteShowing) {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(value: "create4") {
                            Text("다음")
                                .font(.mmg(.subheader3))
                                .frame(width: 100, height: 50)
                                .background(.Red_2)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(30)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AppointCreate3View(path: AppointView(isTabBarHidden: .constant(true)).$path)
        .environment(NewAppointViewModel())
}
