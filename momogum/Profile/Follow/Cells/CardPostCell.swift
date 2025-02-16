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
            // 밥일기 이미지
            if let firstImageURL = mealDiary.foodImageURLs.first, let url = URL(string: firstImageURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(Color.black_5)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 166, height: 241)
                .cornerRadius(8)
            }
            
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
                Text(mealDiary.keyWord.first ?? "")
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
                    Text(mealDiary.keyWord.first ?? "")
                        .font(.mmg(.Caption1))
                        .frame(width: 90, height: .infinity, alignment: .leading)
                        .foregroundColor(Color.black_1)
                        .lineLimit(1)
                }
                .frame(width: 130, height: .infinity, alignment: .leading)
                .padding(.top, 162)
                .padding(.trailing, 10)
            }
            
            // 또 올래요 스티커
            if mealDiary.isRevisit != "NOT_GOOD" {
                Image("good_fill")
                    .resizable()
                    .frame(width: 36,height: 36)
                    .padding(.top, 45)
                .padding(.leading, 115)}
        }
    }
}

#Preview {
    CardPostCell(selectedSegment: .constant(1), mealDiary: MealDiary(
        mealDiaryId: 1,
        foodImageURLs: ["https://i.pinimg.com/736x/ce/1a/bb/ce1abb170c23b41ae415f590351174ad.jpg"],
        userImageURL: "https://i.pinimg.com/736x/f0/51/e0/f051e0c2829fc33cb50fd4db098c3b89.jpg",
        foodCategory: "KOREAN",
        keyWord: ["스시스시스시스시", "delicious"],
        isRevisit: "NOT_GOOD"
    ))
}
