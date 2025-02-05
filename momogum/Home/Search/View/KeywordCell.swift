//
//  KeywordCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct KeywordCell: View {
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<6, id: \.self) { index in
                    VStack(spacing: 0) {
                        // 상단 이미지 부분
                        Rectangle()
                            .fill(Color.gray) // 사진 대신 회색으로 표시 (이미지로 교체 가능)
                            .frame(width: 166, height: 166)
                        
                        // 하단 흰색 배경
                        ZStack {
                            Color.white
                                .frame(width: 166, height: 75) // 하단 부분 높이: 241 - 166 = 75
                            
                            // 프로필 이미지와 텍스트
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.gray) // 프로필 이미지 대신 회색 원
                                    .frame(width: 36, height: 36)
                                
                                Text("식사메뉴 \(index + 1)")
                                    .font(.mmg(.Caption1))
                                    .foregroundColor(.black)
                                
                                Spacer() // 남은 공간 채우기
                            }
                            .frame(width: 144, height: 36) // 전체 프레임
                        }
                    }
                    .frame(width: 166, height: 241)
                    .cornerRadius(10) // 전체 사각형 테두리 둥글게
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) 
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 16) // 좌우 여백
        }
    }
}
