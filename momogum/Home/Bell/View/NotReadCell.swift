//
//  NotReadCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct NotReadCell: View {
    var title: String
    var message: String
    var time: String
    
    var body: some View {
        HStack {
            Image("pixelsImage")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.mmg(.subheader4))
                    .foregroundColor(.black)
                
                Text(message)
                    .font(.mmg(.Caption3))
                    .foregroundColor(.black_2)
                
                Text(time)
                    .font(.mmg(.Caption3))
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .frame(width: 330, height: 72)
        .padding(.leading, 26)
        .background(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    NotReadCell(title: "새 댓글", message: "당신의 게시글에 새로운 댓글이 달렸습니다.", time: "5분 전")
}
