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
    
    var mealDiaryId: Int

    var body: some View {
        HStack {
            Button(action: {
                showCommentBottomSheet = true
            }) {
                Image("comment")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            Spacer().frame(width: 12)

            Text("\(viewModel.myCard.commentCount)")
                .font(.system(size: 16))
        }
        .sheet(isPresented: $showCommentBottomSheet) {
            CommentBottomSheetView(viewModel: viewModel, mealDiaryId: mealDiaryId)
                .presentationDetents([.fraction(2/3)])
        }
        .onAppear {
            viewModel.fetchMealDiary(mealDiaryId: mealDiaryId)
        }
    }
}
