//
//  KeyboardObservers.swift
//  momogum
//
//  Created by 류한비 on 2/16/25.
//

import SwiftUI

class KeyboardObservers: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var offset: CGFloat

    init(offset: CGFloat = 0) {
        self.offset = offset
        addKeyboardObservers()
    }

    deinit {
        removeKeyboardObservers()
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self, let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            DispatchQueue.main.async {
                self.keyboardHeight = keyboardFrame.height - self.offset // 뷰에서 전달된 offset 반영
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            DispatchQueue.main.async {
                self?.keyboardHeight = 0
            }
        }
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
