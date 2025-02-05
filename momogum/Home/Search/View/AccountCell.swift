//
//  AccountCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct AccountCell: View {
    var userID: String
    var name: String
    
    var body: some View {
        HStack {
            Circle() // 프로필 이미지
                .frame(width: 64, height: 64)
                .foregroundColor(.black_5) 
            
            VStack(alignment: .leading) {
                Text(userID)
                    .font(.mmg(.subheader4))
                    .foregroundColor(.black)
                
                Text(name)
                    .font(.mmg(.Caption3))
                    .foregroundColor(.gray)
            }
            .padding(.leading, 2)
            
            Spacer()
        }
        .frame(width: 330, height: 64)
        .background(Color.white) // 셀 배경색
        .cornerRadius(8)
    }
}

