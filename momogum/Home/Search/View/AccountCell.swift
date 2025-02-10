//
//  AccountCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct AccountCell: View {
    var account: AccountSearchResult // 🔹 기존 뷰 유지, API 데이터 적용

    var body: some View {
        HStack {
            // 🔹 프로필 이미지 (API에서 가져온 데이터 사용)
            AsyncImage(url: URL(string: account.userImageURL)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 64, height: 64)
            }

            VStack(alignment: .leading) {
                Text(account.userName) // 🔹 기존 뷰 유지, API 데이터 적용
                    .font(.mmg(.subheader4))
                    .foregroundColor(.black)

                Text(account.userNickName) // 🔹 기존 뷰 유지, API 데이터 적용
                    .font(.mmg(.Caption3))
                    .foregroundColor(.gray)
            }
            .padding(.leading, 2)

            Spacer()
        }
        .frame(width: 330, height: 64)
        .background(Color.white)
        .cornerRadius(8)
    }
}
