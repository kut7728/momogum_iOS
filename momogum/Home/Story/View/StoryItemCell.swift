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
                        if !viewed {
                            Circle()
                                .strokeBorder(
                                    LinearGradient(gradient: Gradient(colors: [
                                        Color(.Red_3),
                                        Color(.momogumRed)
                                    ]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 6
                                )
                                .frame(width: 90, height: 90)
                        } else {
                            Circle()
                                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 6)
                                .frame(width: 90, height: 90)
                        }
                        
                        Image("pixelsImage")  //  스토리 이미지 (추후 API 연결 가능)
                            .resizable()
                            .frame(width: 76, height: 76)
                            .clipShape(Circle())
                    }
                    Text(nickname)
                        .bold()
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
