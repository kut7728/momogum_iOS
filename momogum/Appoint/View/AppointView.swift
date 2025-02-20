//
//  AppointView.swift
//  momogum
//
//  Created by nelime on 1/16/25.
//

import SwiftUI

/// 약속잡기 메인 페이지
struct AppointView: View {
    @State var isPresented: Bool = false
    @State var path: [String] = []
    @State var newAppointViewModel = NewAppointViewModel()
    @State var viewModel = AppointViewModel()
    
    @Binding var isTabBarHidden: Bool
    
    /// 자세한 초대장 확인 뷰에 들어갈 데이터
    @State var targetAppoint: Appoint = Appoint.DUMMY_APM
    
    var body: some View {
        NavigationStack (path: $path) {
            ScrollView {
                VStack (alignment: .leading) {
                    Button {
                        Task {
                            await newAppointViewModel.getAppointId() // 약속 id 할당 POST
                            await newAppointViewModel.getAvailableFriends() // 초대 가능 친구 GET
                        }
                        path.append("create1")
                        isTabBarHidden = true
                    } label: {
                        Rectangle()
                            .frame(width: 336, height: 146)
                            .tint(Color.white.opacity(1))
                            .overlay(RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 3)
                                .tint(.gray.opacity(0.5)))
                            .overlay {
                                VStack {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .foregroundStyle(.gray.opacity(0.5))
                                        .padding(.bottom, 16)
                                    
                                    Text("식사 약속 만들기")
                                        .foregroundStyle(.black)
                                        .font(.mmg(.subheader3))
                                }
                            }
                            .padding(.vertical, 30)
                    }
                    .navigationDestination(for: String.self) { value in
                        if value == "create1" {
                            AppointCreate1View(path: $path)
                                .environment(newAppointViewModel)
                        } else if (value == "create2") {
                            AppointCreate2View(path: $path)
                                .environment(newAppointViewModel)
                        } else if (value == "create3") {
                            AppointCreate3View(path: $path)
                                .environment(newAppointViewModel)
                        } else if (value == "create4") {
                            AppointCreate4View(path: $path, appointViewModel: $viewModel)
                                .environment(newAppointViewModel)
                        } else {
                            AppointSentView(path: $path, appoint: newAppointViewModel.newAppoint ?? Appoint.DUMMY_APM)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    // MARK: - 미확정 약속 목록
                    VStack (alignment: .leading) {
                        Text("수락 대기 중인 약속")
                            .font(.mmg(.subheader3))
                            .padding(.leading, 30)
                        
                        
                        if (viewModel.pendingAppoints.isEmpty) {
                            Rectangle()
                                .foregroundStyle(.black_5)
                                .frame(width: 336, height: 156)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(maxWidth: .infinity)
                                .overlay {
                                    Text("약속 초대를 받으면 여기에 표시됩니다.")
                                        .font(.mmg(.subheader4))
                                        .foregroundStyle(.black_3)
                                }
                                .padding(.vertical, 20)
                        } else {
                            Text("당신의 결정을 기다리는 약속이 있어요!")
                                .font(.mmg(.subheader4))
                                .padding(.leading, 30)
                            
                            
                            ScrollView (.horizontal, showsIndicators: true) {
                                HStack {
                                    Spacer()
                                        .frame(width: 30)
                                    
                                    ForEach(viewModel.pendingAppoints) { appoint in
                                        WaitingConfirmCellView(isPresented: $isPresented, appoint: appoint)
                                    }
                                }
                            }
                            .padding(.vertical, 20)
                            .scrollIndicators(.hidden)
                        }
                        
                        
                        // MARK: - 확정 약속 목록
                        Text("다가오는 식사 약속")
                            .font(.mmg(.subheader3))
                            .padding(.leading, 30)
                        
                        if (viewModel.confirmedAppoints.isEmpty) {
                            
                            // 확정 약속이 없는 경우
                            Rectangle()
                                .foregroundStyle(.black_5)
                                .frame(width: 336, height: 156)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(maxWidth: .infinity)
                                .overlay {
                                    Text("다가오는 식사 약속은 여기에 표시됩니다.")
                                        .font(.mmg(.subheader4))
                                        .foregroundStyle(.black_3)
                                }
                                .padding(.vertical, 20)
                            
                        } else {
                            
                            // 확정 약속이 있는 경우
                            ScrollView (.horizontal, showsIndicators: true) {
                                HStack {
                                    Spacer()
                                        .frame(width: 30)
                                    
                                    ForEach(viewModel.confirmedAppoints) { appoint in
                                        NearAppointCellView(isPresented: $isPresented, targetAppoint: $targetAppoint, appoint: appoint)
                                    }
                                }
                            }
                            .padding(.vertical, 10)
                            .scrollIndicators(.hidden)
                        }
                        
                        Spacer()
                            .frame(height: 100)
                        
                    }
                }
            }
            .refreshable {
                viewModel.loadMyAppoints()
            }
            .task {
                viewModel.loadMyAppoints()
                isTabBarHidden = false
            }
            .fullScreenCover(isPresented: $isPresented) {
                AppointCheckingView(appoint: targetAppoint)
            }
        }
    }
}

#Preview {
    AppointView(isTabBarHidden: .constant(true))
}
