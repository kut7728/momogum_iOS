import Foundation
import SwiftUI

struct KeyboardHider {
    static func hideKeyboard() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = GestureHandler.shared
        window.addGestureRecognizer(tapRecognizer)
    }
}

class GestureHandler: NSObject, UIGestureRecognizerDelegate {
    static let shared = GestureHandler()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

