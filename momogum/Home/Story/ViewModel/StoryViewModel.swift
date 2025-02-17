import SwiftUI
import Alamofire

class StoryViewModel: ObservableObject {
    @Published var rawStories: [StoryResult] = []  //  여러 개의 친구들의 스토리를 저장
    @Published var selectedStory: StoryDetailResult?
    @Published var groupedStories : [String:[StoryResult]] = [:]
    @Published var sortedGroupedStories: [(key: String, value: [StoryResult])] = []  // 정렬된 데이터를 배열로 저장
    @Published var Mystories : [MyStoryResult] = []
    
    // 회원 친구들의 스토리 전체 조회
    func fetchStory(for memberId: Int) {
        let url = "\(BaseAPI)/meal-stories/memberId/\(memberId)" // API 요청 URL
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: StoryModel.self) { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.rawStories = data.result // 안본거 앞에두기
                        self.groupStories()
                        print(" API 응답 성공, stories 개수: \(self.rawStories.count)")
                    }
                case .failure(let error):
                    print( error)
                    print("스토리 불러오기 실패: \(error.localizedDescription)")
                }
            }
    }
    
    // 스토리 상세 내역 가져오기 PK값, mealDiaryStoryId
    func fetchStoryDetail(for memberId: Int,storyId: Int) {
        let url = "\(BaseAPI)/meal-stories/memberId/\(memberId)/storyId/\(storyId)"  //  상세 조회
        self.selectedStory = nil
        print("개별 스토리 API 호출: \(url)")
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
                    print(error)
                    print("개별 스토리 불러오기 실패: \(error.localizedDescription)")
                }
            }
    }
    
    //데이터 분류
    func groupStories() {
        DispatchQueue.global(qos: .userInitiated).async { //백그라운드 스레드에서 실행
            let grouped = Dictionary(grouping: self.rawStories){$0.nickname} //닉네임으로 그룹핑
            
            let sortedGroupedStories = grouped
                       .mapValues { stories in
                           stories.sorted { !$0.viewed && $1.viewed }  // ✅ 같은 닉네임 내에서 viewed == false 먼저 정렬
                       }
                       .sorted { lhs, rhs in
                           let lhsHasUnviewed = lhs.value.contains { !$0.viewed }
                           let rhsHasUnviewed = rhs.value.contains { !$0.viewed }

                           if lhsHasUnviewed == rhsHasUnviewed {
                               return lhs.key < rhs.key  //같은 viewed 상태라면 닉네임 기준으로 정렬
                           }
                           return lhsHasUnviewed && !rhsHasUnviewed  //  viewed == false가 포함된 닉네임이 먼저 오게 정렬
                       }
            DispatchQueue.main.async {
                       self.groupedStories = grouped
                    self.sortedGroupedStories = sortedGroupedStories  //  정렬된 데이터를 배열로 저장

                print(" 닉네임 정렬 완료! \(sortedGroupedStories.map { "\($0.key): \($0.value.map { $0.viewed })" })")

                   }
        }
    }
    
    // nickname값 가져오기(중복확인 절차를 거친)
    func getStoryIDs(for nickname: String) -> [Int] {
        return groupedStories[nickname]?.map { $0.id } ?? []  // 닉네임에 해당하는 모든 스토리 ID 반환
    }

    
    
    func fetchMyStory(for memberId: Int) {
        let url = "\(BaseAPI)/meal-stories/myStories/memberId/\(memberId)"
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: MyStoryModel.self) { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.Mystories = data.result
                        print("내 스토리 가져오기 성공: \(data.result)의 스토리")
                    }
                case .failure(let error):
                    print(error)
                    print("내 스토리 가져오기 실패: \(error.localizedDescription)")
                }
            }
        
        
    }
    
}
