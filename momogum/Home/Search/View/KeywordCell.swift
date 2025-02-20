//
//  KeywordCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import SwiftUI

struct KeywordCell: View {
    let keyword: KeywordSearchResult

    var body: some View {
        VStack(spacing: 0) {
            // 음식 이미지
            AsyncImage(url: URL(string: keyword.foodImageURL)) { image in
                image.resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 166, height: 166)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(Color.black_4)
                    .frame(width: 166, height: 166)
            }

            // 사용자 정보 & 음식 이름
            ZStack {
                Color.white
                    .frame(width: 166, height: 75)

                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: keyword.userImageURL)) { image in
                        image.resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 36, height: 36)
                    }

                    Text(keyword.foodName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black_1)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()
                }
                .frame(width: 144, height: 36)
            }
        }
        .frame(width: 166, height: 241)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black_4, lineWidth: 1)
        )
    }
}



#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
            KeywordCell(keyword: KeywordSearchResult(
                id: 0,
                foodImageURL: "https://via.placeholder.com/166",
                userImageURL: "https://via.placeholder.com/36",
                foodName: "김치찌개",
                isRevisit: "yes"
            ))
            
            KeywordCell(keyword: KeywordSearchResult(
                id: 0,
                foodImageURL: "https://via.placeholder.com/166",
                userImageURL: "https://via.placeholder.com/36",
                foodName: "된장찌개",
                isRevisit: "yes"
            ))
            

        }
        .padding(.leading, 24)
    }
}
