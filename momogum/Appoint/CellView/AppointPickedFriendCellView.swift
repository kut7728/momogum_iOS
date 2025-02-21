//
//  AppointPickedFriendCellView.swift
//  momogum
//
//  Created by nelime on 1/17/25.
//

import SwiftUI

struct AppointPickedFriendCellView: View {
    @Environment(NewAppointViewModel.self) var appointViewModel
    @State var friend: Friend
    
    var body: some View {
        @Bindable var viewModel = appointViewModel
        
        ZStack {
            if let url = URL(string: friend.profileImage) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    Image("good")
                        .resizable()
                        .frame(width: 50, height: 50)
                    .clipShape(Circle())                }
                
            } else {
                Image("good")
                    .resizable()
                    .frame(width: 50, height: 50)
                .clipShape(Circle())
            }
            
            
//            Image("emptyAvatar")
//                .resizable()
//                .frame(width: 50, height: 50)
//                .foregroundStyle(.gray.opacity(0.2))
            
            Button {
                viewModel.pickedFriends.removeAll(where: { $0.nickname == friend.name })
            } label: {
                Image("close_cc")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 18, height: 18)
            }
            .offset(x: 18, y: -18)
        }
        .padding(.top, 3)
        .padding(.trailing, 3)
        .padding(.bottom, 10)
    }
    
}

#Preview {
    AppointPickedFriendCellView(friend: Friend.demoFriends)
        .environment(NewAppointViewModel())
}
