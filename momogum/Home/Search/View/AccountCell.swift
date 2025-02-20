//
//  AccountCell.swift
//  momogum
//
//  Created by 김윤진 on 2/5/25.
//

import Foundation
import SwiftUI

struct AccountCell: View {
    var account: AccountSearchResult
    var isFollowedByOthers: Bool
    var followersText: String? // "(유저이름)님 외 n명이 팔로우합니다." 형식
    
    init(account: AccountSearchResult) {
        self.account = account
        self.isFollowedByOthers = account.searchFollowCount > 0 // 팔로우 수 1명 이상이면 true
        
        // ✅ searchFollowName이 nil일 경우 빈 배열로 대체하여 안전하게 처리
        let followNames = account.searchFollowName ?? []
        
        if let firstFollower = followNames.first, account.searchFollowCount > 1 {
            self.followersText = "\(firstFollower)님 외 \(account.searchFollowCount - 1)명이 팔로우합니다."
        } else if let firstFollower = followNames.first {
            self.followersText = "\(firstFollower)님이 팔로우합니다."
        } else {
            self.followersText = nil
        }
    }
    
    var body: some View {
        HStack {
            ZStack {
                if let url = URL(string: account.userImageURL), !account.userImageURL.isEmpty {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 64, height: 64)
                    }
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 64, height: 64)
                }
                
                Circle()
                    .strokeBorder(
                        account.hasStory ? 
                        (account.hasViewedStory ?
                         LinearGradient(gradient: Gradient(colors: [
                            Color.black_4, Color.black_4  // 본 스토리는 검정 단색
                         ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                         :
                            LinearGradient(gradient: Gradient(colors: [
                                Color.Red_3, Color.momogumRed  // 안 본 스토리는 빨강 그라데이션
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        :
                            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        , lineWidth: 3
                    )
                    .frame(width: 70, height: 70)
                
            }
            
            VStack(alignment: .leading) {
                Text(account.userName)
                    .font(.mmg(.subheader4))
                    .foregroundColor(.black_1)
                
                HStack {
                    Text(account.userNickName)
                        .font(.mmg(.Caption3))
                        .foregroundColor(.black_2)
                    
                    if isFollowedByOthers, let followersText = followersText {
                        Text("ㅣ")
                            .foregroundColor(.black_2)
                            .padding(.leading, 4)
                        
                        Text(followersText)
                            .font(.mmg(.Caption3))
                            .foregroundColor(.black_2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            }
            .padding(.leading, 2)
            
            Spacer()
        }
        .frame(width: 350)
        .frame(height:70)
        .padding(.leading, 31)
        .background(Color.white)
        .cornerRadius(8)
    }
}

//// ✅ 미리보기 코드
//#Preview {
//    VStack {
//        AccountCell(account: AccountSearchResult(
//            id: 0,
//            userName: "김윤진",
//            userNickName: "yunjin_kim",
//            userImageURL: "https://via.placeholder.com/64",
//            searchFollowName: ["김윤진"],
//            searchFollowCount: 1,
//            hasStory: false,
//            hasViewedStory: false
//        ))
//
//        AccountCell(account: AccountSearchResult(
//            id: 1,
//            userName: "박지민",
//            userNickName: "jimin_park",
//            userImageURL: "",
//            searchFollowName: ["김윤진", "박지민"],
//            searchFollowCount: 5,
//            hasStory: true,
//            hasViewedStory: true
//        ))
//    }
//}
