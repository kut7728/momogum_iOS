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
    
    private func selectCard(_ value: String) {
        if appointViewModel.pickedImage != value {
            appointViewModel.pickedImage = value
            withAnimation {
                isPicked = true
            }
        } else {
            appointViewModel.pickedImage = ""
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
                                ForEach(0..<5) { i in
                                    Rectangle()
                                        .frame(width: 170, height: 120)
                                        .foregroundStyle(.black_5)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay{
                                            if appointViewModel.pickedImage == String(i) {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(lineWidth: 3)
                                                    .foregroundStyle(.Red_2)
                                            }
                                        }
                                        .onTapGesture {
                                            selectCard(String(i))
                                        }
                                        .padding(1)
                                }
                            }
                        }
                        
                        
                        Text("재미")
                            .font(.mmg(.subheader4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                        
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(6..<10) { i in
                                    Rectangle()
                                        .frame(width: 170, height: 120)
                                        .foregroundStyle(.black_5)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay{
                                            if appointViewModel.pickedImage == String(i) {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(lineWidth: 3)
                                                    .foregroundStyle(.Red_2)
                                            }
                                        }
                                        .onTapGesture {
                                            selectCard(String(i))
                                        }
                                        .padding(1)
                                }
                            }
                        }
                        
                        
                        Text("진중")
                            .font(.mmg(.subheader4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                        
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(10..<15) { i in
                                    Rectangle()
                                        .frame(width: 170, height: 120)
                                        .foregroundStyle(.black_5)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay{
                                            if appointViewModel.pickedImage == String(i) {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(lineWidth: 3)
                                                    .foregroundStyle(.Red_2)
                                            }
                                        }
                                        .onTapGesture {
                                            selectCard(String(i))
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
                ApmHoveringNavButton(navLinkValue: "create3")
            }
        }
    }
}

#Preview {
    AppointCreate2View(path: AppointView(isTabBarHidden: .constant(true)).$path)
        .environment(NewAppointViewModel())

}
