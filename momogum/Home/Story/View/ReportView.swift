//
//  ReportView.swift
//  momogum
//
//  Created by 김윤진 on 1/31/25.
//

import SwiftUI

struct ReportView: View {
    @Binding var showReportSheet: Bool // Story2View에서 모달 제어
    @Binding var showPopup: Bool // Story2View에서 팝업 제어
    
    var body: some View {
        VStack {
            // 헤더
            Text("신고하기")
                .font(.headline)
                .padding(.top, 12)
            
            Rectangle()
                .frame(width: 300, height: 1)
                .padding(.top, 24)
                .foregroundColor(.gray)
            
            Text("이 게시물을 신고하는 사유를 선택해주세요.")
                .font(.mmg(.subheader4))
                .padding(.top, 50)
            
            Text("신고는 익명으로 처리됩니다")
                .font(.mmg(.Body4))
                .padding(.top, 20)
            
            Rectangle()
                .frame(width: 300, height: 1)
                .padding(.top, 64)
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                ReportCellView(title: "잘못된 정보") {
                    closeModalAndShowPopup()
                }
                Rectangle()
                    .frame(width: 300, height: 1)
                    .foregroundColor(.gray)

                ReportCellView(title: "상업적 광고") {
                    closeModalAndShowPopup()
                }
                Rectangle()
                    .frame(width: 300, height: 1)
                    .foregroundColor(.gray)

                ReportCellView(title: "음란물") {
                    closeModalAndShowPopup()
                }
                Rectangle()
                    .frame(width: 300, height: 1)
                    .foregroundColor(.gray)

                ReportCellView(title: "폭력성") {
                    closeModalAndShowPopup()
                }
                Rectangle()
                    .frame(width: 300, height: 1)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
    }

    // 신고 셀을 누르면 모달을 닫고 팝업을 표시하는 함수
    private func closeModalAndShowPopup() {
        showReportSheet = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 모달이 닫힌 후 팝업 표시 (0.3초 딜레이)
            showPopup = true
        }
    }
}

// 신고 사유 셀 뷰
struct ReportCellView: View {
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.mmg(.Body3))
                .foregroundColor(.black) // 텍스트 색상 유지
                .padding(.leading, 20)
            Spacer()
        }
        .frame(width: 300, height: 50)
        .onTapGesture {
            onTap()
        }
    }
}
