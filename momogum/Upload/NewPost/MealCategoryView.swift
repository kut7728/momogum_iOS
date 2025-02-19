//
//  MealCategoryView.swift
//  momogum
//
//  Created by 조승연 on 1/30/25.
//

import SwiftUI

struct MealCategoryView: View {
    let categories: [String]
    @Binding var selectedCategory: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text("식사 카테고리 선택")
                .font(.headline)
                .padding(.leading, 24)

            Spacer().frame(height: 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedCategory == category ? .white : .black)
                            .padding(.horizontal, 12)
                            .frame(height: 32)
                            .fixedSize(horizontal: true, vertical: false)
                            .background(selectedCategory == category ? Color.momogumRed : Color.placeholderGray3)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.borderGray, lineWidth: 1)
                            )
                            .onTapGesture {
                                selectedCategory = category
                            }
                    }
                }
                .padding(.horizontal, 22)
            }
        }
    }
}
