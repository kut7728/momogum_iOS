//
//  AppointCreateCompleteView.swift
//  momogum
//
//  Created by nelime on 1/20/25.
//
//

import SwiftUI

// MARK: - struct
/// 초대장 생성 이후 약속 내용을 확인하는 뷰
struct AppointCheckingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var showConfirmPopUp: Bool = false
    @State var showCanclePopUp: Bool = false
    
    let appoint: Appoint
    
    let dateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy년 M월 d일 HH:mm"
        fmt.locale = Locale(identifier: "ko-KR")
        return fmt
    }
    
    // MARK: - body
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    /// 초대장
                    VStack (alignment: .leading) {
                        
                        /// 초대장 이미지
                        Image(appoint.pickedCard)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 170)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        /// 선택된 친구들
                        ApmInvitedFriends(pickedFriends: appoint.pickedFriends, isEditing: false)
                        
                        /// 각 속성들의 묶음
                        VStack (alignment: .leading, spacing: 30) {
                            
                            ///타이틀과 항목 묶음
                            VStack(alignment: .leading, spacing: 10) {
                                Text("식사 메뉴")
                                    .font(.mmg(.Body3))
                                
                                
                                Text(appoint.menuName)
                                    .font(.mmg(.subheader4))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("식사 일정")
                                    .font(.mmg(.Body3))
                                
                                
                                Text("\(appoint.pickedDate, formatter: dateFormatter())")
                                    .font(.mmg(.subheader4))
                            }
                            
                            
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("만나는 장소")
                                    .font(.mmg(.Body3))
                                
                                
                                Text(appoint.placeName)
                                    .font(.mmg(.subheader4))
                            }
                            
                            
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("추가 메모")
                                    .font(.mmg(.Body3))
                                
                                
                                Text(appoint.note)
                                    .font(.mmg(.subheader4))
                            }
                            
                            
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 350)
                    }
                    .padding(.horizontal, 20)
                    .background(.black_5)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    
                    /// 버튼들
                    HStack {
                        Button {
                            withAnimation {
                                showCanclePopUp = true
                            }
                        } label: {
                            Text("약속 취소")
                                .font(.mmg(.subheader3))
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lineWidth: 2)
                                }
                                .foregroundStyle(.Red_2)
                        }
                        
                        Spacer()
                            .frame(width: 25)
                        
                        Button {
                            withAnimation {
                                showConfirmPopUp = true
                            }
                        } label: {
                            Text("약속 확정")
                                .font(.mmg(.subheader3))
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lineWidth: 2)
                                }
                                .foregroundStyle(.black_3)
                        }
                        
                    }
                    .padding(.vertical, 20)
                }
                .padding(20)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(appoint.appointName)
                .navigationBarBackButtonHidden(true)
                .toolbarVisibility(.hidden, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image("back")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 5)
                                .foregroundStyle(.black)
                        }
                    }
                }
                
                if showConfirmPopUp {
                    appointConfirmPopup()
                }
                
                if showCanclePopUp {
                    appointCancelPopup()
                }
            }
        }
    }
}

// MARK: - extensions
extension AppointCheckingView {
    func appointConfirmPopup() -> some View {
        CustomPopUpView(showPopUp: $showConfirmPopUp,
                        title: "약속을 확정해요",
                        message: "지금까지 초대를 수락한 참가자와 약속을 확정합니다. 더 이상 다른 참가자가 초대를 수락할 수 없습니다.",
                        btn1: "돌아가기",
                        btn2: "약속 확정")

    }
    
    func appointCancelPopup() -> some View {
        CustomPopUpView(showPopUp: $showCanclePopUp,
                        title: "약속을 취소해요",
                        message: "취소된 약속은 다시 불러올 수 없습니다.",
                        btn1: "돌아가기",
                        btn2: "약속 취소")

    }
    
    
}

#Preview {
    AppointCheckingView(appoint: Appoint.DUMMY_APM)
}
