import SwiftUI
import Alamofire

class StoryViewModel: ObservableObject {
    @Published var stories: [StoryResult] = []  //  여러 개의 친구들의 스토리를 저장
    @Published var selectedStory: StoryDetailResult?
    func fetchStory(for memberId: Int) {
        let url = "\(BaseAPI)/meal-stories/memberId/\(memberId)" // API 요청 URL

        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: StoryModel.self) { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.stories = data.result.sorted{ !$0.viewed && $1.viewed} // 안본거 앞에두기
                        print(" API 응답 성공, stories 개수: \(self.stories.count)")
                    }
                case .failure(let error):
                    print("스토리 불러오기 실패: \(error.localizedDescription)")
                }
            }
    }
    
    func fetchStoryDetail(for memberId: Int,storyId: Int) {
         let url = "\(BaseAPI)/meal-stories/memberId/\(memberId)/storyId\(storyId)"  //  상세 조회
        self.selectedStory = nil
         print("📡 개별 스토리 API 호출: \(url)")
         AF.request(url, method: .get)
             .validate()
             .responseDecodable(of: StoryDetailModel.self) { response in
                 switch response.result {
                 case .success(let data):
                     DispatchQueue.main.async {
                         self.selectedStory = data.result
                         print("개별 스토리 응답 성공: \(data.result.name)의 스토리")
                     }
                 case .failure(let error):
                     print("개별 스토리 불러오기 실패: \(error.localizedDescription)")
                 }
             }
     }
}
