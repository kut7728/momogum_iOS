//
//  ReportCompletedView.swift
//  momogum
//
//  Created by 조승연 on 2/5/25.
//

import SwiftUI

struct ReportCompletedView: View {
    @Binding var showCompletedModal: Bool

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Text("신고가 접수되었습니다.")
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.center)

                Text("검토는 최대 24시간 소요됩니다.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Divider()
                    .frame(width: 280, height: 0.5)
                    .background(Color.gray.opacity(0.5))

                Button(action: {
                    showCompletedModal = false
                }) {
                    Text("확인")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 10)
            }
            .frame(width: 319, height: 185)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)

            Spacer()
        }
        .background(Color.black.opacity(0.4).ignoresSafeArea())
    }
}

#Preview {
    ReportCompletedView(showCompletedModal: .constant(false))
}
