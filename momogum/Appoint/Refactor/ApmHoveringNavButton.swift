//
//  ApmHoveringNavButton.swift
//  momogum
//
//  Created by nelime on 1/31/25.
//

import SwiftUI

struct ApmHoveringNavButton: View {
    @Environment(\.dismiss) var dismiss
    let navLinkValue: String
    var isEditing:Bool { navLinkValue == "" }
    
    var body: some View {
        if !isEditing {
            NavigationLink(value: navLinkValue) {
                Text("다음")
                    .font(.mmg(.subheader3))
                    .frame(width: 100, height: 50)
                    .background(.Red_2)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(30)
                
            }
        } else {
            Button {
                dismiss()
            } label: {
                Text("완료")
                    .font(.mmg(.subheader3))
                    .frame(width: 100, height: 50)
                    .background(.Red_2)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(30)
            }

        }
    }
}

#Preview {
    ApmHoveringNavButton(navLinkValue: "")
}
