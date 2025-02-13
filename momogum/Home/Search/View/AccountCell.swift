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

        // followersText 자동 생성
        if let firstFollower = account.searchFollowName.first, account.searchFollowCount > 1 {
            self.followersText = "\(firstFollower)님 외 \(account.searchFollowCount - 1)명이 팔로우합니다."
        } else if let firstFollower = account.searchFollowName.first {
            self.followersText = "\(firstFollower)님이 팔로우합니다."
        } else {
            self.followersText = nil
        }
    }

    var body: some View {
        HStack {
            // 프로필 이미지 (API에서 가져온 데이터 사용)
            AsyncImage(url: URL(string: account.userImageURL)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.black_4)
                    .frame(width: 64, height: 64)
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
        .frame(maxWidth: .infinity)
        .frame(height:64)
        .padding(.leading, 31)
        .background(Color.white)
        .cornerRadius(8)
    }
}

//#Preview {
//    VStack {
//        AccountCell(account: AccountSearchResult(
//            id: 0,
//            userName: "김윤진",
//            userNickName: "yunjin_kim",
//            userImageURL: "https://via.placeholder.com/64",
//            searchFollowName: ["김윤진"],
//            searchFollowCount: 1
//        ))
//        
//        AccountCell(account: AccountSearchResult(
//            id: 1,
//            userName: "박지민",
//            userNickName: "jimin_park",
//            userImageURL: "https://via.placeholder.com/64",
//            searchFollowName: ["김윤진", "박지민"],
//            searchFollowCount: 5
//        ))
//    }
//}
