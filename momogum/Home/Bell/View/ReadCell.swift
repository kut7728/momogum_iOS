//
//  ReadCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct ReadCell: View {
    var title: String
    var message: String
    var time: String
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 48, height: 48)
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.mmg(.subheader4))
                    .foregroundColor(.black_2)
                
                Text(message)
                    .font(.mmg(.Caption3))
                    .foregroundColor(.black_3)
                
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
    ReadCell(title: "게시글 좋아요", message: "당신의 게시글이 좋아요를 받았습니다.", time: "2일 전")
}
