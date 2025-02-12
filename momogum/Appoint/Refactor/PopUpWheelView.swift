import SwiftUI

struct PopUpWheelView: View {
    // MARK: - properites
    // 해당 프로퍼티로 팝업을 띄울지 말지를 부모뷰의 state 값으로 전달 받을 예정
    @Binding var showPopUpWheel: Bool
    @Binding var pickedDate: Date
    
    
    
    // MARK: - body
    var body: some View {
        
        ZStack {
            
            /// Background - 팝업을 띄울 때 팝업 외 배경을 어둡게 하고자 했다
            Rectangle()
                .background(.black)
                .opacity(0.2)
            
            VStack(spacing: 12) {
                DatePicker("", selection: $pickedDate)
                    .frame(maxWidth: .infinity)
                    .labelsHidden()
                    .datePickerStyle(.wheel)
                    .environment(\.locale, Locale(identifier: String(Locale.preferredLanguages[0])))
                    .background(.black_5)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.black_4)
                    })
                
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
            
        }
        // ZStack을 화면에 꽉 채우도록 해서 fullScreen처럼 보이게 함
        .ignoresSafeArea(.all)
        .onTapGesture {
                showPopUpWheel = false
        }
    }
}

#Preview {
    PopUpWheelView(showPopUpWheel: .constant(false), pickedDate: .constant(Date()))
}
