//
//  HeartBottomSheet.swift
//  momogum
//
//  Created by 조승연 on 2/5/25.
//

import SwiftUI

struct HeartBottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CardViewModel
    var mealDiaryId: Int

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
                ForEach(viewModel.likedUsers, id: \.nickname) { user in
                    HStack {
                        if let imagePath = user.userProfileImage, let url = URL(string: imagePath) {
                            AsyncImage(url: url) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(user.nickname)
                                .font(.system(size: 16, weight: .bold))
                            Text(user.name)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 160, alignment: .leading)
                    }
                    .padding(.vertical, 8)
                    .listRowSeparator(.hidden)
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
    }
}
