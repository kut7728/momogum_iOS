//
//  AppointCreate4View.swift
//  momogum
//
//  Created by nelime on 1/20/25.
//

import SwiftUI

/// 약속생성의 4단계, 초대장 생성 직전 마지막 편집하는 뷰
struct AppointCreate4View: View {
    @Environment(\.dismiss) var dismiss
    @Environment(NewAppointViewModel.self) var appointViewModel
    @State private var showPopUpWheel: Bool = false
    
    /// 조건 미충족시 경고 및 버튼 비활성화
    @State var menuNecessary: Bool = false
    @State var titleNecessary: Bool = false
    @State var placeNecessary: Bool = false
    var isButtonShowing: Bool {!self.menuNecessary && !self.titleNecessary && !self.placeNecessary}
    
    @Binding var path: [String]
    
    let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 HH:mm"
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter
    }
    
    // MARK: - 
    var body: some View {
        @Bindable var viewModel = appointViewModel
        
        ScrollView {

            ZStack {
                VStack {
                    Button {
                        path.append("create1")
                    } label: {
                        ApmInvitedFriends(pickedFriends: viewModel.pickedFriends, isEditing: true)
                    }
                    
                    
                    Rectangle()
                        .frame(width: 200, height: 150)
                        .foregroundStyle(.black_5)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.vertical, 30)
                        .overlay {
                            Button {
                                path.append("create2")
                            } label: {
                                Image("pencil")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .contentShape(Rectangle())
                                
                            }
                            .offset(x: 80, y: -55)
                            
                        }
                    
                    
                    
                    VStack (spacing: 20) {
                        HStack {
                            Text("식사 모임명")
                                .font(.mmg(.Body3))
                                .foregroundStyle(.black_2)
                            
                            Spacer()
                            
                            if titleNecessary {
                                Text("*필수입력")
                                    .font(.mmg(.Caption2))
                                    .foregroundStyle(.Red_1)
                            }
                        }
                        
                        ApmEditingTextFieldView(target: $viewModel.appointName, isNecessary: $titleNecessary)
                        
                        HStack {
                            Text("식사 메뉴")
                                .font(.mmg(.Body3))
                                .foregroundStyle(.black_2)
                            
                            Spacer()
                            
                            if menuNecessary {
                                Text("*필수입력")
                                    .font(.mmg(.Caption2))
                                    .foregroundStyle(.Red_1)
                            }
                        }
                        
                        ApmEditingTextFieldView(target: $viewModel.menuName, isNecessary: $menuNecessary)
                        
                        Text("식사 일정")
                            .font(.mmg(.Body3))
                            .foregroundStyle(.black_2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ZStack {
                            Text("\(viewModel.pickedDate, formatter: dateFormatter())")
                                .modifier(ApmTextFieldViewModifier())
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation {
                                        showPopUpWheel = true
                                    }
                                } label: {
                                    Image("pencil")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                }
                                .padding(.trailing, 10)
                            }
                            
                            
                        }
                        
                        
                        HStack {
                            Text("만나는 장소")
                                .font(.mmg(.Body3))
                                .foregroundStyle(.black_2)
                            
                            Spacer()
                            
                            if placeNecessary {
                                Text("*필수입력")
                                    .font(.mmg(.Caption2))
                                    .foregroundStyle(.Red_1)
                            }
                        }
                        
                        ApmEditingTextFieldView(target: $viewModel.placeName, isNecessary: $placeNecessary)
                        
                        Text("추가 메모")
                            .font(.mmg(.Body3))
                            .foregroundStyle(.black_2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ApmEditingTextFieldView(target: $viewModel.note, isNecessary: .constant(false))
                        
                        Button {
                            viewModel.createAppoint()
                            path.append("Sent")
                        } label: {
                            Text("초대장 보내기")
                                .font(.mmg(.subheader3))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(isButtonShowing ? .Red_2 : .black_4)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("약속잡기")
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image("back")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 5)
                                .foregroundStyle(.black)
                        }
                        
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.resetAppoint()
                            path.removeLast(path.count)
                        } label: {
                            Image("close")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 5)
                                .foregroundStyle(.black)
                        }
                    }
                }
                
                if showPopUpWheel {
                    PopUpWheelView(showPopUpWheel: $showPopUpWheel, pickedDate: $viewModel.pickedDate)
                }

            }
        }
        
    }
}

#Preview {
    AppointCreate4View(path: AppointView(isTabBarHidden: .constant(true)).$path)
        .environment(NewAppointViewModel())

}
