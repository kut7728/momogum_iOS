//
//  NearAppointCellView.swift
//  momogum
//
//  Created by nelime on 1/16/25.
//

import SwiftUI

struct NearAppointCellView: View {
    @Binding var isPresented: Bool
    @Binding var targetAppoint: Appoint

    let appoint: Appoint
    
    let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    
    var body: some View {
        
        Rectangle()
            .frame(width: 215, height: 170)
            .foregroundStyle(.black_6)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundStyle(.black_4))
            .overlay {
                VStack (alignment: .leading, spacing: 0) {
                    
                    // 약속 날짜
                    Text("\(appoint.pickedDate, formatter: dateFormatter())")
                        .font(.mmg(.Caption2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 약속 장소
                    Text(appoint.placeName)
                        .font(.mmg(.Caption2))

                    Spacer()
                    
                    // 약속 이름
                    Text(appoint.appointName)
                        .font(.mmg(.subheader3))
                        .padding(.bottom, 5)
                    
                    // 약속 메뉴
                    HStack {
                        Image("menu")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text(appoint.menuName)
                            .font(.mmg(.Caption2))
                    }

                    
                    Spacer()
                    
                    Button {
                        targetAppoint = appoint
                        isPresented = true
                        } label: {
                            Text("약속 자세히 보기")
                                .font(.mmg(.Caption1))
                                .frame(width: 170, height: 30)
                                .background(.black_6)
                                .foregroundStyle(.Red_2)
                                .overlay(RoundedRectangle(cornerRadius: 4)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(.Red_2)
                                )
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 15)
            }
            .padding(3)
    }
}

#Preview {
    NearAppointCellView(isPresented: .constant(false), targetAppoint: .constant(Appoint.DUMMY_APM), appoint: Appoint.DUMMY_APM)
}
