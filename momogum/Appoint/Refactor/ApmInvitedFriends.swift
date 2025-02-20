//
//  ApmInvitedFriends.swift
//  momogum
//
//  Created by nelime on 2/6/25.
//

import SwiftUI

struct ApmInvitedFriends: View {
    let pickedFriends: [Friend]
    let isEditing: Bool
    
    var body: some View {
        HStack(spacing: -10) {
            ForEach(pickedFriends, id: \.name) { profile in
                
                if let url = URL(string: profile.profileImage) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Image("pixelsImage")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    
                } else {
                    Image("pixelsImage")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
//                Image("emptyAvatar")
//                    .resizable()
//                    .frame(width: 40, height: 40)
            }
                
            
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(isEditing ? .black_5 : .black_6)
                .overlay {
                    Image(isEditing ? "pencil" : "dots")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.black_3)
                }
        }
    }
}

#Preview {
    ApmInvitedFriends(pickedFriends: NewAppointViewModel().pickedFriends, isEditing: false)
}
