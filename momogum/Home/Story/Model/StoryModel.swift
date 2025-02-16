import Foundation

// MARK: - StoryModel (전체 스토리 조회)
struct StoryModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [StoryResult]  //  여러 개의 스토리 배열
}

// MARK: - StoryResult (개별 스토리 정보)
struct StoryResult: Codable, Identifiable {
    let id: Int  //
    let nickname: String
    let mealDiaryImageLinks: String
    let viewed: Bool

    enum CodingKeys: String, CodingKey {
        case id = "mealDiaryStoryId"  //
        case nickname, mealDiaryImageLinks, viewed
    }
}
