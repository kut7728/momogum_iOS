//
//  ApmEditingTextFieldView.swift
//  momogum
//
//  Created by nelime on 1/29/25.
//

import SwiftUI


struct ApmEditingTextFieldView: View {
    @State var isEditing = false
    @Binding var target: String
    @Binding var isNecessary: Bool

    private let addingNote = "특별한 소식이 있다면 남겨주세요 :)"
    
    var body: some View {
        if isEditing {
            TextField(target, text: $target)
                .modifier(ApmTextFieldModifier(target: target, isNecessary: $isNecessary))
                .onSubmit {
                    isEditing = false
                }
        } else {
            ZStack {
                Text(target == "" ? addingNote : target)
                    .modifier(ApmTextFieldModifier(target: target, isNecessary: $isNecessary))

                
                HStack {
                    Spacer()
                    
                    Button {
                        isEditing = true
                    } label: {
                        Image("pencil")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .padding(.trailing, 10)
                }
            }
        }
    }
}

#Preview {
    ApmEditingTextFieldView(target: .constant("something"), isNecessary: .constant(false))
}
