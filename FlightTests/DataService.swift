import Foundation
import RxSwift

class DataService {
    private var questions = BehaviorSubject<[Question]>(value: [])
    
    static let data = DataService()
    
    func changeData(data: [Question]) {
        self.questions.onNext(data)
    }
    
    func getData() -> [Question] {
        do {
            return try self.questions.value()
        } catch {
            print(error)
        }
        return []
    }
    
}
