//
//  KeywordCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct KeywordCell: View {
    let keyword: KeywordSearchResult // 🔹 기존 뷰 유지, API 데이터 적용

    var body: some View {
        VStack(spacing: 0) {
            // 🔹 기존 뷰 유지, API 데이터 적용
            AsyncImage(url: URL(string: keyword.foodImageURL)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 166, height: 166)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 166, height: 166)
            }

            ZStack {
                Color.white
                    .frame(width: 166, height: 75)

                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: keyword.userImageURL)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 36, height: 36)
                    }

                    Text(keyword.foodName) // 🔹 기존 뷰 유지, API 데이터 적용
                        .font(.mmg(.Caption1))
                        .foregroundColor(.black)

                    Spacer()
                }
                .frame(width: 144, height: 36)
            }
        }
        .frame(width: 166, height: 241)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}
