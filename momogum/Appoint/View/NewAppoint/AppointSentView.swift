//
//  AppointSentView.swift
//  momogum
//
//  Created by nelime on 1/21/25.
//

import SwiftUI

/// 약속생성의 마지막 단계, 초대장을 보냈다는 화면 + 초대장 확인 버튼
struct AppointSentView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var path: [String]
    
    @State var isPresented: Bool = false
    var appoint: Appoint
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("초대장 보내기 완료!")
                .font(.mmg(.subheader2))
                .padding(.bottom, 20)
            
            Image(appoint.pickedCard)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 270)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            Button {
                isPresented = true
            } label: {
                Text("초대장 확인하기")
                    .font(.mmg(.subheader3))
                    .frame(width: 280, height: 60)
                    .background(.black_6)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 1)
                    }
                    .foregroundStyle(.Red_2)
                
                
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isPresented) {
            AppointCheckingView(appoint: appoint)
        }
        
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
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
    }
}

#Preview {
    let appointView = AppointView.init(isTabBarHidden: .constant(true))
    
    AppointSentView(path: appointView.$path, appoint: Appoint.DUMMY_APM)
}
