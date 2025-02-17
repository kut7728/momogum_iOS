import SwiftUI

struct CancleAlarmView: View {
    // MARK: - properites
    // 해당 프로퍼티로 팝업을 띄울지 말지를 부모뷰의 state 값으로 전달 받을 예정
    @Binding var showAlarm: Bool
    
    
    // MARK: - body
    var body: some View {
        
        ZStack {
            
            /// Background - 팝업을 띄울 때 팝업 외 배경을 어둡게 하고자 했다
            Rectangle()
                .background(.black)
                .opacity(0.2)
            
            VStack (alignment: .center) {
                
                Text("약속이 취소되었습니다.")
                    .foregroundStyle(.black_1)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .fontWeight(.bold)
                    .padding(.vertical, 30)
                
              
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 50)
            
        }
        // ZStack을 화면에 꽉 채우도록 해서 fullScreen처럼 보이게 함
        .ignoresSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showAlarm = false
                }
            }
        }
        
    }
}

#Preview {
    CancleAlarmView(
        showAlarm: .constant(false)
    )
}
