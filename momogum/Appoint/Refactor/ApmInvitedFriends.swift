//
//  ApmInvitedFriends.swift
//  momogum
//
//  Created by nelime on 2/6/25.
//

import SwiftUI

struct ApmInvitedFriends: View {
    let pickedFriends: [String]
    let isEditing: Bool
    
    var body: some View {
        HStack(spacing: -10) {
            ForEach(Array(pickedFriends.enumerated()), id: \.1) { index, name in
                Image("emptyAvatar")
                    .resizable()
                    .frame(width: 40, height: 40)
//                    .overlay {
//                        Circle()
//                            .stroke(lineWidth: 1)
//                            .foregroundStyle(.black_4)
//                    }
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
