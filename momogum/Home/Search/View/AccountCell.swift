//
//  AccountCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct AccountCell: View {
    var account: AccountSearchResult

    var body: some View {
        HStack {
            // 프로필 이미지 (API에서 가져온 데이터 사용)
            AsyncImage(url: URL(string: account.userImageURL)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.black_4)
                    .frame(width: 64, height: 64)
            }

            VStack(alignment: .leading) {
                Text(account.userName)
                    .font(.mmg(.subheader4))
                    .foregroundColor(.black_1)

                Text(account.userNickName)
                    .font(.mmg(.Caption3))
                    .foregroundColor(.black_2)
            }
            .padding(.leading, 2)

            Spacer()
        }
        .frame(width: 330, height: 64)
        .background(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    AccountCell(account: AccountSearchResult(
        id: 0,
        userName: "김윤진",
        userNickName: "yunjin_kim",
        userImageURL: "https://via.placeholder.com/64" // 더미 이미지
    ))
}
