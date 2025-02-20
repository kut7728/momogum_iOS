import SwiftUI

/// 약속 수락 팝업
struct ApprovePopUpView: View {
    // MARK: - properites
    // 해당 프로퍼티로 팝업을 띄울지 말지를 부모뷰의 state 값으로 전달 받을 예정
    @Binding var showPopUp: Bool
    @Binding var showAlarm: Bool
    
    let title: String = "약속을 수락할까요?" // 공지 이름
    let btn1: String = "나가기" // 왼쪽 버튼 text
    let btn2: String = "수락하기" // 오른쪽 버튼 text
    
    // MARK: - body
    var body: some View {
        
        ZStack {
            
            /// Background - 팝업을 띄울 때 팝업 외 배경을 어둡게 하고자 했다
            Rectangle()
                .background(.black)
                .opacity(0.2)
            
            VStack(spacing: 12) {
                
                Text(title)
                    .foregroundStyle(.black_1)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .fontWeight(.bold)
                    .padding(.vertical, 20)
                    .padding(.top, 20)
                
                
                Divider()
                
                /// 버튼 뭉치
                HStack(spacing: 8) {
                    
                    /// 왼쪽 버튼 - 나가기
                    Button(action: {
                        showPopUp = false
                    }, label: {
                        Text(btn1)
                            .font(.mmg(.subheader3))
                            .foregroundStyle(.black_2)
                            .padding(.vertical, 8)
                            .frame(width: 100)
                    })
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider()
                    
                    /// 오른쪽 버튼 - 수락하기
                    Button(action: {
                        showPopUp = false
                        withAnimation {
                            showAlarm = true
                        }
                    }, label: {
                        Text(btn2)
                            .font(.mmg(.subheader3))
                            .foregroundStyle(.Red_2)
                            .padding(.vertical, 8)
                            .frame(width: 100)
                    })
                    .frame(maxWidth: .infinity, alignment: .center)

                    
                    
                }
                .frame(height: 44)
                .padding(.bottom, 12)

                
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 50)
            
        }
        // ZStack을 화면에 꽉 채우도록 해서 fullScreen처럼 보이게 함
        .ignoresSafeArea(.all)
        
    }
}

#Preview {
    ApprovePopUpView(
        showPopUp: .constant(false),
        showAlarm: .constant(false)
    )
}
