//
//  NewPostModel.swift
//  momogum
//
//  Created by 조승연 on 1/22/25.
//

import Foundation

struct NewPostModel {
    var selectedCategory: String?
    var tags: [String]
    var mealPlace: String
    var newExperience: String
    var selectedIcon: String?
    var selectedImageData: Data?

    init(selectedCategory: String? = nil, tags: [String] = [], mealPlace: String = "", newExperience: String = "", selectedIcon: String? = nil, selectedImageData: Data? = nil) {
        self.selectedCategory = selectedCategory
        self.tags = tags
        self.mealPlace = mealPlace
        self.newExperience = newExperience
        self.selectedIcon = selectedIcon
        self.selectedImageData = selectedImageData
    }
}
