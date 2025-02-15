//
//  ReportDetailView.swift
//  momogum
//
//  Created by 류한비 on 2/9/25.
//

import SwiftUI

struct ReportDetailView: View {
    @Binding var showReportDetailPopup: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Text("신고가 접수되었습니다.")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.black_2)
                    .padding(.top, 31)

                Text("검토는 최대 24시간 소요됩니다.")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.black_2)

                Divider()
                    .frame(width: 300, height: 1)
                    .foregroundStyle(Color.black_4)
                    .padding(.top, 28)

                Button(action: {
                    showReportDetailPopup = false
                }) {
                    Text("확인")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.Blue_1)
                        .padding(.bottom, 25)
                }
                .padding(.top, 27)
            }
            .frame(width: 319, height: 185)
            .background(Color.black_6)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black_4, lineWidth: 1)
            )

            Spacer()
        }
    }
}

#Preview {
    ReportCompletedView(showCompletedModal: .constant(false))
}
