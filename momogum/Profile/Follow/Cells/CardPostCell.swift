//
//  CardPostCell.swift
//  momogum
//
//  Created by 류한비 on 1/30/25.
//

import SwiftUI

struct CardPostCell: View {
    @Binding var selectedSegment: Int
    var mealDiary: MealDiary
    
    var body: some View {
        ZStack{
            Rectangle() // 추후 이미지로 변경
                .frame(width: 166,height: 241)
                .foregroundStyle(Color.black_5)
                .cornerRadius(8)
            
            Rectangle()
                .foregroundStyle(Color.white)
                .frame(width: 166,height: 75)
                .padding(.top, 168)
            
            Rectangle()
                .frame(width: 166,height: 241)
                .foregroundStyle(Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black_4, lineWidth: 1)
                )
            if selectedSegment == 0{
                    // 식사메뉴
                    Text(mealDiary.foodCategory)
                        .font(.mmg(.Caption1))
                        .frame(width: 130, height: .infinity, alignment: .leading)
                        .foregroundColor(Color.black_1)
                        .padding(.top, 162)
                        .lineLimit(1)
                        .padding(.leading, 11)
            } else if selectedSegment == 1 {
                HStack(alignment:.center, spacing: 0){
                    // 저장된 밥일기 경우 프로필
                    AsyncImage(url: URL(string: mealDiary.userImageURL)) { image in
                        image.resizable()
                    } placeholder: {
                        Image("defaultProfile")
                            .resizable()
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .padding(.trailing, 8)
                    
                    // 식사메뉴
                    Text(mealDiary.foodCategory)
                        .font(.mmg(.Caption1))
                        .frame(width: 90, height: .infinity, alignment: .leading)
                        .foregroundColor(Color.black_1)
                        .lineLimit(1)
                }
                .frame(width: 130, height: .infinity, alignment: .leading)
                .padding(.top, 162)
                .padding(.trailing, 10)
            }
            
        }
    }
}

#Preview {
    CardPostCell(selectedSegment: .constant(1), mealDiary: MealDiary(
        mealDiaryId: 1,
        foodImageURLs: ["https://example.com/food.jpg"],
        userImageURL: "https://example.com/user.jpg",
        foodCategory: "KOREAN",
        keyWord: ["spicy", "delicious"],
        isRevisit: "NOT_GOOD"
    ))
}
