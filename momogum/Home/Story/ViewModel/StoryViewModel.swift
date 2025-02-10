//
//  StoryViewModel.swift
//  momogum
//
//  Created by 김윤진 on 2/9/25.
//

import SwiftUI

class StoryViewModel: ObservableObject {
    @Published var navigateToGallery: Bool = false  // 갤러리로 이동 여부

    // 밥일기 작성 시작 (갤러리 뷰 이동)
    func startWritingStory() {
        navigateToGallery = true
    }
}






