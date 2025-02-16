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
                            .frame(width: 60, height: 32)
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

#Preview {
    MealCategoryView(
        categories: ["한식", "중식", "일식", "양식", "아시안", "패스트푸드", "카페", "기타"],
        selectedCategory: .constant(nil)
    )
}
