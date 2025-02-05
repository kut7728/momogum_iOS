//
//  HomeView.swift
//  momogum
//
//  Created by 김윤진 on 1/21/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var tabIndex: Int
    @State private var selectedButtonIndex: Int? = nil // 선택된 버튼의 인덱스
    @State private var userInput: String = ""
    @State private var unreadNotificationCount: Int = 2 // 예제 데이터 (읽지 않은 알림 수)

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    let normalButtonColor = Color(.systemGray5)
    let selectedButtonColor = Color(red: 224 / 255, green: 90 / 255, blue: 85 / 255) // E05A55

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("LoGo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 107, height: 37)
                        .clipped()
                        .padding(.leading, 20)
                        .padding(.top, 20)

                    Spacer()
                        .frame(width: 124)

                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                            .foregroundStyle(.black)
                            .padding(.trailing, 12)
                            .padding(.top, 20)
                    }

                    Spacer()
                        .frame(width: 20)

                    ZStack {
                        NavigationLink(destination: BellView()) {
                            Image(systemName: "bell")
                                .imageScale(.large)
                                .foregroundStyle(.black)
                                .padding(.trailing, 27)
                                .padding(.top, 20)
                        }

                        // 읽지않은 알림 배지 표시
                        if unreadNotificationCount > 0 {
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 6, height: 6)

                            }
                            .offset(x: 0, y: -10) // Bell 아이콘 오른쪽 상단 배치
                        }
                    }
                }
                .background(Color.clear)
                .cornerRadius(10)
                .padding(.horizontal, 16)

                Spacer()
                    .frame(height: 40)

                // 스토리 섹션
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        VStack {
                            NavigationLink(destination: StoryView(userID: "", tabIndex: $tabIndex)) {
                                ZStack {
                                    Circle()
                                        .strokeBorder(
                                            Color.gray.opacity(0.5),
                                            lineWidth: 6
                                        )
                                        .frame(width: 90, height: 90)

                                    Circle()
                                        .foregroundColor(Color(red: 207 / 255, green: 207 / 255, blue: 207 / 255))
                                        .frame(width: 76, height: 76)
                                }
                            }
                            Text("내 스토리")
                                .bold()
                                .font(.mmg(.Caption2))
                        }
                        .padding(.leading, 24)

                        VStack {
                            NavigationLink(destination: Story2View(userID: "")) {
                                ZStack {
                                    Circle()
                                        .strokeBorder(
                                            LinearGradient(gradient: Gradient(colors: [
                                                Color(red: 249 / 255, green: 143 / 255, blue: 140 / 255),
                                                Color(red: 224 / 255, green: 90 / 255, blue: 85 / 255)
                                            ]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                            lineWidth: 6
                                        )
                                        .frame(width: 90, height: 90)

                                    Circle()
                                        .foregroundColor(Color(red: 207 / 255, green: 207 / 255, blue: 207 / 255))
                                        .frame(width: 76, height: 76)
                                }
                            }
                            Text("momogum._.")
                                .bold()
                                .font(.mmg(.Caption2))
                        }
                        .padding(.leading, 16)
                    }
                }

                Spacer()
                    .frame(height: 60)

                HStack {
                    Text("다양한 밥일기 \n둘러보기")
                        .bold()
                        .font(.mmg(.subheader1))
                        .padding(.leading, 24)
                    Spacer()
                }

                // 버튼 섹션
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<9, id: \.self) { index in
                            Button(action: {
                                selectedButtonIndex = index
                            }) {
                                Text(buttonLabel(for: index))
                                    .font(.mmg(.subheader4))
                                    .padding(.horizontal, 16)
                                    .frame(height: 32)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .background(selectedButtonIndex == index ? selectedButtonColor : normalButtonColor)
                                    .foregroundColor(selectedButtonIndex == index ? .white : .gray)
                                    .bold()
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.top, 24)
                    .padding(.leading, 12)
                }

                if selectedButtonIndex != nil {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(0..<6) { index in
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 166, height: 166)

                                    ZStack {
                                        Color.white
                                            .frame(width: 166, height: 75)

                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 36, height: 36)

                                            Text("식사메뉴")
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
                        .padding(.horizontal, 16)
                    }
                }

                Spacer()
            }
        }
    }

    private func buttonLabel(for index: Int) -> String {
        switch index {
        case 0: return "또올래요:)"
        case 1: return "한식"
        case 2: return "중식"
        case 3: return "일식"
        case 4: return "양식"
        case 5: return "아시안"
        case 6: return "패스트푸드"
        case 7: return "카페"
        case 8: return "기타"
        default: return ""
        }
    }
}

#Preview {
    HomeView(tabIndex: .constant(0))
}
