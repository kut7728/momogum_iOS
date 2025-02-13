//
//  AppointCreate2View.swift
//  momogum
//
//  Created by nelime on 1/20/25.
//

import SwiftUI

/// 약속생성의 2단계, 식사카드를 고르는 뷰
struct AppointCreate2View: View {
    @Environment(NewAppointViewModel.self) var appointViewModel
    @State var isPicked: Bool = false
    @Binding var path: [String]
    
    /// 약속생성 4단계에서 편집으로 넘어왔을때를 판별
    private var isEditingBeforeEnd: Bool { path.dropLast().last == "create4"}
    
    /// 카드 선택 로직
    private func selectCard(_ value: String) {
        if appointViewModel.pickedCard != value {
            appointViewModel.pickedCard = value
            withAnimation {
                isPicked = true
            }
        } else {
            appointViewModel.pickedCard = ""
            withAnimation {
                isPicked = false
            }
        }
    }
        
    var body: some View {
        @Bindable var viewModel = appointViewModel
        
        ApmBackgroundView(path: $path) {
            VStack {
                Text("어울리는 식사 카드를 골라주세요")
                    .font(.mmg(.Body2))
                    .padding(.top, 30)
                
                ScrollView {
                    VStack {
                        Text("기본")
                            .font(.mmg(.subheader4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                        
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(ApmCard.basic, id: \.self) { image in
                                    Image(image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 170)
                                        .overlay{
                                            if appointViewModel.pickedCard == image {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(lineWidth: 3)
                                                    .foregroundStyle(.Red_2)
                                            }
                                        }
                                        .onTapGesture {
                                            selectCard(image)
                                        }
                                        .padding(1)
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(width: 30)
                    }
                    .padding(.leading, 20)
                    
                    VStack {
                        Text("재미")
                            .font(.mmg(.subheader4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                        
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(ApmCard.fun, id: \.self) { image in
                                    Image(image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 170)
                                        .overlay{
                                            if appointViewModel.pickedCard == image {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(lineWidth: 3)
                                                    .foregroundStyle(.Red_2)
                                            }
                                        }
                                        .onTapGesture {
                                            selectCard(image)
                                        }
                                        .padding(1)
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(width: 30)
                    }
                    .padding(.leading, 20)
                    
                    VStack {
                        Text("이벤트")
                            .font(.mmg(.subheader4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                        
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(ApmCard.event, id: \.self) { image in
                                    Image(image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 170)
                                        .overlay{
                                            if appointViewModel.pickedCard == image {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(lineWidth: 3)
                                                    .foregroundStyle(.Red_2)
                                            }
                                        }
                                        .onTapGesture {
                                            selectCard(image)
                                        }
                                        .padding(1)
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(width: 30)
                    }
                    .padding(.leading, 20)
                }
                
            }
            if isPicked {
                ApmHoveringNavButton(navLinkValue: isEditingBeforeEnd ? "" : "create3")
            }
        }
    }
}

#Preview {
    AppointCreate2View(path: AppointView(isTabBarHidden: .constant(true)).$path)
        .environment(NewAppointViewModel())
    
}
