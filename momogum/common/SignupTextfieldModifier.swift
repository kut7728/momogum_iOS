//
//  SignupTextfieldModifier.swift
//  momogum
//
//  Created by 서재민 on 1/13/25.
//

import SwiftUI

struct SignupTextfieldModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .padding(.leading, 11)
            .font(.mmg(.subheader4))
            .padding(.horizontal,32)
            .padding(.top,142)
            .disableAutocorrection(true)
    }
}
