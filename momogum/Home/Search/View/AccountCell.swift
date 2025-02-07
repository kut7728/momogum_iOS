//
//  AccountCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct AccountCell: View {
    var account: Account // 더미 데이터 주입을 위한 모델
    
    var body: some View {
        HStack {
            Circle() // 프로필 이미지
                .frame(width: 64, height: 64)
                .foregroundColor(.black_5)
            
            VStack(alignment: .leading) {
                Text(account.userID) // 더미 데이터 사용
                    .font(.mmg(.subheader4))
                    .foregroundColor(.black)
                
                Text(account.name) // 더미 데이터 사용
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

// PreviewProvider로 더미 데이터 적용
struct AccountCell_Previews: PreviewProvider {
    static let dummyAccounts = [
        Account(userID: "momogum._.", name: "머머금"),
        Account(userID: "john_doe", name: "John Doe"),
        Account(userID: "jane_smith", name: "Jane Smith")
    ]
    
    static var previews: some View {
        VStack(spacing: 16) {
            ForEach(dummyAccounts) { account in
                AccountCell(account: account)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}


