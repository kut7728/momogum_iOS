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
    
    var body: some View {
        NavigationStack (path: $path) {
            ScrollView {
                VStack (alignment: .leading) {
                    Button {
                        path.append("create1")
                        newAppointViewModel.loadAppointmentCard()
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
                            AppointCreate4View(path: $path)
                                .environment(newAppointViewModel)
                        } else {
                            AppointSentView(path: $path)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    VStack (alignment: .leading) {
                        Text("수락 대기 중인 약속")
                            .font(.mmg(.subheader3))
                            .padding(.leading, 30)
                        
                        
                        if (viewModel.appoints.isEmpty) {
                            
                        } else {
                            Text("당신의 결정을 기다리는 약속이 있어요!")
                                .font(.mmg(.subheader4))
                                .padding(.leading, 30)
                            
                            
                            ScrollView (.horizontal, showsIndicators: true) {
                                HStack {
                                    Spacer()
                                        .frame(width: 30)
                                    
                                    ForEach(viewModel.appoints) { appoint in
                                        NearAppointCellView(isPresented: $isPresented, appoint: appoint)
                                    }
                                }
                            }
                            .padding(.vertical, 20)
                            .scrollIndicators(.hidden)
                        }
                        
                        Text("다가오는 식사 약속")
                            .font(.mmg(.subheader3))
                            .padding(.leading, 30)
                        
                        
                        ScrollView (.horizontal, showsIndicators: true) {
                            HStack {
                                Spacer()
                                    .frame(width: 30)
                                
                                ForEach(viewModel.appoints) { appoint in
                                    WaitingConfirmCellView(isPresented: $isPresented, appoint: appoint)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .scrollIndicators(.hidden)
                        
                        Spacer()
                            .frame(height: 100)
                        
                    }
                }
            }
            .refreshable {
                await viewModel.loadAllAppoints()
            }
            .task {
                await viewModel.loadAllAppoints()
                isTabBarHidden = false
            }
            .fullScreenCover(isPresented: $isPresented) {
                AppointCheckingView(appoint: Appoint.DUMMY_APM)
            }
        }
    }
}

#Preview {
    AppointView(isTabBarHidden: .constant(true))
}
