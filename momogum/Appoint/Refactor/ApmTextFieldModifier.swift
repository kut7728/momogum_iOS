//
//  ApmTextFieldModifier.swift
//  momogum
//
//  Created by nelime on 1/28/25.
//

import SwiftUI

struct ApmTextFieldModifier: ViewModifier {
    var target: String
    @Binding var isNecessary: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.mmg(.Body3))
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.leading)
            .frame(height: 50)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.black_5)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                if !isNecessary {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.black_4)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.Red_1)
                }
                
            }
            .onChange(of: target) { oldValue, newValue in
                if oldValue != "" && newValue == "" {
                    isNecessary = true
                } else if newValue != "" {
                    isNecessary = false
                }
            }
        
    }
}
