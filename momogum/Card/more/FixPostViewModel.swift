//
//  FixPostViewModel.swift
//  momogum
//
//  Created by 조승연 on 2/6/25.
//

import Foundation
import SwiftUI

class FixPostViewModel: ObservableObject {
    @Published var fixPost = FixPostModel(selectedCategory: nil, tags: [], mealPlace: "", newExperience: "", selectedIcon: nil)

    func updateSelectedCategory(_ category: String) {
        fixPost.selectedCategory = category
    }

    func updateTags(_ tags: [String]) {
        fixPost.tags = tags
    }

    func updateMealPlace(_ place: String) {
        fixPost.mealPlace = place
    }

    func updateExperience(_ experience: String) {
        fixPost.newExperience = experience
    }

    func updateSelectedIcon(_ icon: String) {
        fixPost.selectedIcon = icon
    }

    func resetPost() {
        fixPost = FixPostModel(selectedCategory: nil, tags: [], mealPlace: "", newExperience: "", selectedIcon: nil)
    }
}
