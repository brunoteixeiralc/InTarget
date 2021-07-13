//
//  NoAlvoTests.swift
//  NoAlvoTests
//
//  Created by Bruno Corrêa on 11/06/21.
//

import XCTest
import Firebase
import CoreData
@testable import InTarget

class InTargetTests: XCTestCase {
    
    /*
     what to test:
     - database reference firebase - OK
     - uuid is created (not empty) - OK
     - start new game (verify score, round, currentvalue) - OK
     - start new round (verify score, round, currentvalue) - OK
     - score points - OK
     - save content to firebase
     - save name to coreData
     - fetch name to coreData
     */
    
    let viewModel = MainViewModel()

    func testDatabaseRef() throws {
        viewModel.configDatabase()
        XCTAssertEqual(viewModel.scoreRef.url, "https://intarget-f1a9e-default-rtdb.firebaseio.com/target_scores")
    }
    
    func testUUIDFetch() throws {
        XCTAssertNotNil(viewModel.uuid)
    }
    
    func testStartNewGame() throws {
        viewModel.startNewGame()
        XCTAssertEqual(viewModel.score.value, 0)
        XCTAssertEqual(viewModel.round.value, 1)
        XCTAssertEqual(viewModel.currentValue, 50)
        XCTAssertLessThanOrEqual(viewModel.target.value, 100)
    }
    
    func testStartNewRound() throws {
        viewModel.startNewRound()
        XCTAssertEqual(viewModel.round.value, 1)
        XCTAssertEqual(viewModel.currentValue, 50)
        XCTAssertLessThanOrEqual(viewModel.target.value, 100)
    }
    
    func testScorePointsRandom() throws {
        let _ = viewModel.calculateScoreAndMessage()
        XCTAssertNotEqual(viewModel.score.value, 0)
    }
    
    func testScorePointsPerfect() throws {
        viewModel.currentValue = 80
        viewModel.target.value = 80
        let result = viewModel.calculateScoreAndMessage()
        XCTAssertNotEqual(viewModel.score.value, 0)
        XCTAssertEqual(result.title, NSLocalizedString("Perfect!", comment: "Perfect!"))
    }
    
    func testScorePointsAlmost() throws {
        viewModel.currentValue = 76
        viewModel.target.value = 80
        let result = viewModel.calculateScoreAndMessage()
        XCTAssertNotEqual(viewModel.score.value, 0)
        XCTAssertEqual(result.title, NSLocalizedString("You almost had it!", comment: "You almost had it!"))
    }
    
    func testScorePointsPrettyGood() throws {
        viewModel.currentValue = 71
        viewModel.target.value = 80
        let result = viewModel.calculateScoreAndMessage()
        XCTAssertNotEqual(viewModel.score.value, 0)
        XCTAssertEqual(result.title, NSLocalizedString("Pretty good!", comment: "Pretty good!"))
    }

    func testScorePointsNotEvenClose() throws {
        viewModel.currentValue = 60
        viewModel.target.value = 80
        let result = viewModel.calculateScoreAndMessage()
        XCTAssertNotEqual(viewModel.score.value, 0)
        XCTAssertEqual(result.title, NSLocalizedString("Not even close...", comment: "Not even close..."))
    }
    
    func testScoreSaveFirebase() throws {
        viewModel.configDatabase()
        viewModel.score.value = 1000
        viewModel.saveScoreDatabase()
    }
    
    func testSaveNameCoreDate() throws {
        viewModel.configDatabase()
        viewModel.saveName(name: "Bruno")
        viewModel.fetchName()
    }
}
