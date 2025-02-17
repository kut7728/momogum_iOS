//
//  CommentView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct CommentView: View {
    @State private var showCommentBottomSheet = false
    @ObservedObject var viewModel: MyCardViewModel

    var body: some View {
        HStack {
            Button(action: {
                showCommentBottomSheet = true
            }) {
                Image("comment")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Spacer().frame(width: 12)

            Text("\(viewModel.myCard.commentCount)")
                .font(.system(size: 16))
        }
        .sheet(isPresented: $showCommentBottomSheet) {
            CommentBottomSheetView()
                .presentationDetents([.fraction(2/3)]) 
        }
    }
}
