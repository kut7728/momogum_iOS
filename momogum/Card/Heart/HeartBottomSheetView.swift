//
//  HeartBottomSheet.swift
//  momogum
//
//  Created by 조승연 on 2/5/25.
//

import SwiftUI

struct HeartBottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    struct User: Identifiable {
        let id = UUID()
        let username: String
        let name: String
        var isFollowing: Bool
    }

    @State private var likeUsers = [
        User(username: "유저아이디", name: "이름", isFollowing: true),
        User(username: "유저아이디", name: "이름", isFollowing: false),
        User(username: "유저아이디", name: "이름", isFollowing: true),
        User(username: "유저아이디", name: "이름", isFollowing: true),
        User(username: "유저아이디", name: "이름", isFollowing: false),
        User(username: "유저아이디", name: "이름", isFollowing: true),
        User(username: "유저아이디", name: "이름", isFollowing: false)
    ]

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top, 8)
            
            Text("좋아요")
                .font(.system(size: 18, weight: .semibold))
                .padding(.top, 24)

            Divider()
                .frame(width: 304.5, height: 0.5)
                .background(Color.gray.opacity(0.5))
                .padding(.top, 24)
            
            List {
                ForEach(likeUsers.indices, id: \.self) { index in
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 52, height: 52)
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(likeUsers[index].username)
                                .font(.system(size: 16, weight: .bold))
                            Text(likeUsers[index].name)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 160, alignment: .leading)
                        
                        Spacer()

                        Button(action: {
                            likeUsers[index].isFollowing.toggle()
                        }) {
                            Text(likeUsers[index].isFollowing ? "팔로잉" : "팔로우")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 72, height: 28)
                                .background(likeUsers[index].isFollowing ? Color.white : Color.red)
                                .foregroundColor(likeUsers[index].isFollowing ? .red : .white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.red, lineWidth: likeUsers[index].isFollowing ? 1 : 0)
                                )
                                .cornerRadius(4)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, 16)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 0)
        .presentationDetents([.fraction(2/3)])
    }
}

#Preview {
    HeartBottomSheetView()
}
