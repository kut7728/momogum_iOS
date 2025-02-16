//
//  ReportPopupView.swift
//  momogum
//
//  Created by 류한비 on 2/9/25.
//

import SwiftUI

struct ReportPopupView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showReportDetailPopup: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 44, height: 2)
                .foregroundStyle(Color.black_2)
                .padding(.bottom, 24)
                .padding(.top, 21)
            
            Text("신고하기")
                .font(.mmg(.subheader3))
                .padding(.bottom, 24)
            
            Rectangle()
                .frame(width:300, height: 1)
                .foregroundStyle(Color.black_4)
                .padding(.bottom, 52)
            
            Text("이 게시물을 신고하는 사유를 선택해주세요.")
                .font(.mmg(.subheader4))
                .foregroundStyle(Color.black_2)
                .padding(.bottom, 20)
            Text("신고는 익명으로 처리됩니다")
                .font(.mmg(.Body4))
                .foregroundStyle(Color.black_2)
                .padding(.bottom, 68)
            
            Rectangle()
                .frame(width: 300, height: 1)
                .foregroundStyle(Color.black_4)
            
            VStack(alignment: .leading, spacing: 0){
                reportOption(text: "잘못된 정보")
                reportOption(text: "상업적 광고")
                reportOption(text: "음란물")
                reportOption(text: "폭력성")
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.black_6)
        .cornerRadius(36)
        .overlay(
            RoundedRectangle(cornerRadius: 36)
                .stroke(Color.black_5, lineWidth: 2)
        )
        .background(.clear)
    }
    
    // MARK: - 신고 항목 버튼
    private func reportOption(text: String) -> some View {
        Button {
            print("\(text) 신고 선택됨")
            dismiss()
            showReportDetailPopup = true
        } label: {
            VStack(alignment: .leading, spacing: 0){
                HStack(alignment: .center, spacing: 0){
                    Text(text)
                        .font(.mmg(.Body3))
                        .foregroundStyle(Color.black_1)
                        .padding(.leading, 19)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .padding(.vertical, 22)
                .padding(.horizontal, 43)
                
                
                Rectangle()
                    .frame(width: 300, height: 1)
                    .foregroundStyle(Color.black_4)
                    .padding(.leading, 43)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ReportPopupView(showReportDetailPopup: .constant(false))
}
