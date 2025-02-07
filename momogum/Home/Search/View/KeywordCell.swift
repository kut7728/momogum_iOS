//
//  KeywordCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct KeywordCell: View {
    let keyword: Keyword // 더미 데이터 주입을 위한 모델

    var body: some View {
        VStack(spacing: 0) {
            // 상단 이미지 부분
            Rectangle()
                .fill(Color.gray) // 사진 대신 회색으로 표시 (이미지로 교체 가능)
                .frame(width: 166, height: 166)
            
            // 하단 흰색 배경
            ZStack {
                Color.white
                    .frame(width: 166, height: 75)

                // 프로필 이미지와 텍스트
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.gray) // 프로필 이미지 대신 회색 원
                        .frame(width: 36, height: 36)
                    
                    Text(keyword.title) // 더미 데이터 사용
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

// PreviewProvider로 더미 데이터 적용
struct KeywordCell_Previews: PreviewProvider {
    static let dummyKeywords = [
        Keyword(title: "한식"),
        Keyword(title: "중식"),
        Keyword(title: "일식"),
        Keyword(title: "양식"),
        Keyword(title: "패스트푸드"),
        Keyword(title: "디저트")
    ]
    
    static var previews: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(dummyKeywords) { keyword in
                    KeywordCell(keyword: keyword)
                }
            }
            .padding(.horizontal, 16)
        }
        .previewLayout(.sizeThatFits)
    }
}
