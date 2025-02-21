//
//  AppointFriendListCellView.swift
//  momogum
//
//  Created by nelime on 1/17/25.
//

import SwiftUI

struct AppointFriendListCellView: View {
    let profile: Friend
    
    var body: some View {
        HStack {
            if let url = URL(string: profile.profileImage) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.trailing)
                } placeholder: {
                    Image("good")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.trailing)
                }
                
            } else {
                Image("good")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.trailing)
            }
            
//            Image("emptyAvatar")
//                .resizable()
//                .frame(width: 50, height: 50)
//                .foregroundStyle(.gray.opacity(0.2))
//                .padding(.trailing)
            
            VStack (alignment: .leading) {
                Text(profile.nickname)
                    .font(.mmg(.subheader4))
                
                Text(profile.name)
                    .font(.mmg(.Caption3))
            }
            Spacer()
        }
    }
}

#Preview {
    AppointFriendListCellView(profile: Friend.demoFriends)
}
