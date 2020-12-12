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
        print("DB \(db)")
        createTable()
    }
    
    let dbPath: String = "db.sqlite3"
    var db: Connection!
    let id = Expression<Int64>("id")
    let correctAnswers = Expression<Int64>("correctAnswers")
    let wrongAnswers = Expression<Int64>("wrongAnswers")
    let statisticsTable = Table("statistics")
    
    func openDatabase() -> Connection? {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                .first!
            print("Opening db")
            return try Connection("\(path)/\(dbPath)")
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func createTable() {
        print("Creating table")
        do {
            try self.db.run(statisticsTable.create(ifNotExists: true, block: { (t) in
                t.column(id, primaryKey: true)
                t.column(correctAnswers)
                t.column(wrongAnswers)
            }))
            let checkIfExists = self.statisticsTable.filter(id == 1)
            print("CCHECK IF: \(checkIfExists)")
            if checkIfExists == nil {
                try self.db.run(statisticsTable.insert(id <- 1, correctAnswers <- 0, wrongAnswers <- 0))
            }
        } catch {
            print(error)
        }
    }
    
    func update(correct: Int, wrong: Int) {
        let tempStat = self.read()
        let currentStatistic = statisticsTable.filter(id == 1)
        do {
            try self.db.run(currentStatistic.update(correctAnswers <- Int64(tempStat.correctAnswers + correct), wrongAnswers <- Int64(tempStat.wrongAnswers + wrong)))
        } catch {
            print(error)
        }
    }
    
    func read() -> Statistics {
        let statistic = Statistics()
        
        do {
            for tmpStatistic in try db!.prepare(statisticsTable) {
                print("TEMP \(tmpStatistic)")
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
}
