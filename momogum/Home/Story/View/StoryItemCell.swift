//
//  StoryItemCell.swift
//  momogum
//
//  Created by 서재민 on 2/16/25.
//

import SwiftUI

import SwiftUI
    // 스토리 셀입니다
struct StoryItemCell: View {
    let nickname: String
    let viewed: Bool
    let storyIDs: [Int]  //  닉네임에 해당하는 모든 스토리 ID 목록 추가
    let storyViewModel: StoryViewModel
    let destination: AnyView
    let hasUnViewedStory: Bool
    let profileImageLink: String
    @Binding var isTabBarHidden: Bool
    var body: some View {
        VStack{
            NavigationLink(
                destination: destination
                                    .onAppear { isTabBarHidden = true }
                                    
                )
             {
                VStack {
                    ZStack {
                        if hasUnViewedStory {
                            Circle()
                                .strokeBorder(
                                    LinearGradient(gradient: Gradient(colors: [
                                        Color(.Red_3),
                                        Color(.momogumRed)
                                    ]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 4
                                )
                                .frame(width: 90, height: 90)
                                .padding(3)
                        } else {
                            Circle()
                                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 4)
                                .frame(width: 90, height: 90)
                                .padding(3)
                        }
                        
                        AsyncImage(url: URL(string: profileImageLink)) { image in
                                                image.resizable()
                                                    .scaledToFill()
                                            } placeholder: {
                                                Image(systemName: "person.circle.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(width: 76, height: 76)
                                            .clipShape(Circle())
                        
                    }
                    Text(nickname)
                        .bold()
                        .foregroundColor(.black)
                        .font(.mmg(.Caption2))
                }
                .padding(.leading, 24)
            }
        }
    }
}

//#Preview {
//    StoryItemCell()
//}
