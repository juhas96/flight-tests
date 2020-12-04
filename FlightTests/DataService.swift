//
//  DataService.swift
//  FlightTests
//
//  Created by Jakub Juh on 04/12/2020.
//

import Foundation
import RxSwift

class DataService {
    private var questions = BehaviorSubject<[Question]>(value: [])
//    var currentData: Observable<[Question]>

//    init() {
//        currentData = questions.asObserver()
//    }
    
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
