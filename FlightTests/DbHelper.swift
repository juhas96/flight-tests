//
//  DbHelper.swift
//  FlightTests
//
//  Created by Jakub Juh on 09/12/2020.
//

import Foundation
import SQLite

class DbHelper {
    init() {
        db = openDatabase()
        createStatisticsTable()
        createTestHistoryTable()
    }
    
    let dbPath: String = "db.sqlite3"
    var db: Connection!
    let id = Expression<Int64>("id")
    let correctAnswers = Expression<Int64>("correctAnswers")
    let wrongAnswers = Expression<Int64>("wrongAnswers")
    let statisticsTable = Table("statistics")
    let testHistoryTable = Table("oldTests")
    let questionIdsArray = Expression<String>("questionIds")
    let userAnswers = Expression<String>("userAnswers")
    
    func openDatabase() -> Connection? {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                .first!

            return try Connection("\(path)/\(dbPath)")
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func createStatisticsTable() {
        do {
            try self.db.run(statisticsTable.create(ifNotExists: true, block: { (t) in
                t.column(id, primaryKey: true)
                t.column(correctAnswers)
                t.column(wrongAnswers)
            }))
            
            try self.db.run(statisticsTable.insert(id <- 1, correctAnswers <- 0, wrongAnswers <- 0))
        } catch {
            print(error)
        }
    }
    
    func createTestHistoryTable() {
        do {
            try self.db.run(testHistoryTable.create(ifNotExists: true, block: { (t) in
                t.column(id, primaryKey: true)
                t.column(questionIdsArray)
                t.column(userAnswers)
            }))
        } catch {
            print(error)
        }
    }
    
    func updateStatistics(correct: Int, wrong: Int) {
        let tempStat = self.readStatistics()
        let currentStatistic = statisticsTable.filter(id == 1)
        do {
            try self.db.run(currentStatistic.update(correctAnswers <- Int64(tempStat.correctAnswers + correct), wrongAnswers <- Int64(tempStat.wrongAnswers + wrong)))
        } catch {
            print(error)
        }
    }
    
    func readStatistics() -> Statistics {
        let statistic = Statistics()
        
        do {
            for tmpStatistic in try db!.prepare(statisticsTable) {
                if (tmpStatistic[self.id] == 1) {
                    statistic.correctAnswers = Int(tmpStatistic[self.correctAnswers])
                    statistic.wrongAnswers = Int(tmpStatistic[self.wrongAnswers])
                }
            }
        } catch {
            print(error)
        }
        return statistic
    }
    
    func readAllUserTests() -> [UserTest] {
        var returningArray = [UserTest]()
        
        do {
            let items = try db.prepare(testHistoryTable)
            
            for item in items {
                let questionIds = item[self.questionIdsArray].components(separatedBy: ",")
                let userAnswers = item[self.userAnswers].components(separatedBy: ",")
                returningArray.append(UserTest(id: Int(item[self.id]), questionIds: questionIds, userAnswers: userAnswers))
            }
        } catch {
            print(error)
        }
        return returningArray
    }
    
    func insertIntoUserTests(test: UserTest) -> Int64 {
        let questionIds = test.questionIds.joined(separator: ",")
        let answers = test.userAnswers.joined(separator: ",")
        
        let insert = testHistoryTable.insert(questionIdsArray <- questionIds, userAnswers <- answers)
        
        do {
            let rowId = try self.db.run(insert)
            guard rowId >= 0 else {
                return -1
            }
            return rowId
        } catch {
            print(error)
        }
        
        return -2
    }
    
    
}
