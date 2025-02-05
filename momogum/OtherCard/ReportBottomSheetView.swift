//
//  ReportBottomsheetView.swift
//  momogum
//
//  Created by 조승연 on 2/5/25.
//

import SwiftUI

struct ReportBottomSheet: View {
    @Binding var isPresented: Bool
    @Binding var showCompletedModal: Bool

    let reasons = ["잘못된 정보", "상업적 광고", "음란물", "폭력성"]

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top, 8)
            
            Text("신고하기")
                .font(.system(size: 18, weight: .semibold))
                .padding(.top, 24)

            Divider()
                .frame(width: 304.5, height: 0.5)
                .background(Color.gray.opacity(0.5))
                .padding(.top, 24)
            
            Text("이 게시물을 신고하는 사유를 선택해주세요.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            Text("신고는 익명으로 처리됩니다.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            Divider()
                .frame(width: 304.5, height: 0.5)
                .background(Color.gray.opacity(0.5))
                .padding(.top, 40)

            VStack(spacing: 0) {
                ForEach(reasons, id: \.self) { reason in
                    Button(action: {
                        print("\(reason) 신고 선택됨")
                        isPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showCompletedModal = true
                        }
                    }) {
                        Text(reason)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                            .padding(.leading, 40)
                    }
                    Divider()
                        .frame(width: 304.5, height: 0.5)
                        .background(Color.gray.opacity(0.5))
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
    }
}

#Preview {
    ReportBottomSheet(isPresented: .constant(false), showCompletedModal: .constant(false))
}
