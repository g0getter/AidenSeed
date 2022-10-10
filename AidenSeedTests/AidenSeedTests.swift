//
//  AidenSeedTests.swift
//  AidenSeedTests
//
//  Created by 여나경 on 2022/10/10.

// 참고
// - https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
// - https://developer.apple.com/documentation/xctest/xctestcase/set_up_and_tear_down_state_in_your_tests
// - https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial

import XCTest

@testable import AidenSeed

class AidenSeedTests: XCTestCase {
    var sut: SearchUserViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = SearchUserViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
//      let guess = sut.getFilledResultCell(userInfo: userInfo)
        // TODO: Q. 테스트를 위해 private func으로 설정하면 안될지?
        
        // when
//      sut.check(guess: guess1)
        
        // then
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFirstDigitIsComputed() {
        let userID1 = 1
        let userID2 = 2
        let userID3 = 3
        let userID4 = 4
        let userID5 = 5
        let userID6 = 6
        let userID7 = 7
        let userID8 = 8
        let userID9 = 9
        
        let guess1 = KeywordType.getFirstDigit(userID1)
        let guess2 = KeywordType.getFirstDigit(userID2)
        let guess3 = KeywordType.getFirstDigit(userID3)
        let guess4 = KeywordType.getFirstDigit(userID4)
        let guess5 = KeywordType.getFirstDigit(userID5)
        let guess6 = KeywordType.getFirstDigit(userID6)
        let guess7 = KeywordType.getFirstDigit(userID7)
        let guess8 = KeywordType.getFirstDigit(userID8)
        let guess9 = KeywordType.getFirstDigit(userID9)
        
        XCTAssertEqual(guess1, "1", "First digit computed from guess1 is wrong")
        XCTAssertEqual(guess2, "2", "First digit computed from guess2 is wrong")
        XCTAssertEqual(guess3, "3", "First digit computed from guess3 is wrong")
        XCTAssertEqual(guess4, "4", "First digit computed from guess4 is wrong")
        XCTAssertEqual(guess5, "5", "First digit computed from guess5 is wrong")
        XCTAssertEqual(guess6, "6", "First digit computed from guess6 is wrong")
        XCTAssertEqual(guess7, "7", "First digit computed from guess7 is wrong")
        XCTAssertEqual(guess8, "8", "First digit computed from guess8 is wrong")
        XCTAssertEqual(guess9, "9", "First digit computed from guess9 is wrong")
    }

    func testKeywordTypeIsComputedWhenUserIDFirstDigitIsLessThanOrEqualWithFive() {
      // given
        let userID1 = 1
        let userID2 = 2
        let userID3 = 3
        let userID4 = 4
        let userID5 = 5
        
        let guess1 = KeywordType.getKeywordType(userID: userID1)
        let guess2 = KeywordType.getKeywordType(userID: userID2)
        let guess3 = KeywordType.getKeywordType(userID: userID3)
        let guess4 = KeywordType.getKeywordType(userID: userID4)
        let guess5 = KeywordType.getKeywordType(userID: userID5)
        
      // then
        XCTAssertEqual(guess1, .imageRight, "KeywordType computed from guess1 is wrong")
        XCTAssertEqual(guess2, .imageRight, "KeywordType computed from guess2 is wrong")
        XCTAssertEqual(guess3, .imageRight, "KeywordType computed from guess3 is wrong")
        XCTAssertEqual(guess4, .imageRight, "KeywordType computed from guess4 is wrong")
        XCTAssertEqual(guess5, .imageRight, "KeywordType computed from guess5 is wrong")
    }
    
    func testKeywordTypeIsComputedWhenUserIDFirstDigitIsGreaterThanFive() {
      // given
        let userID6 = 6
        let userID7 = 7
        let userID8 = 8
        let userID9 = 9
        
        let guess6 = KeywordType.getKeywordType(userID: userID6)
        let guess7 = KeywordType.getKeywordType(userID: userID7)
        let guess8 = KeywordType.getKeywordType(userID: userID8)
        let guess9 = KeywordType.getKeywordType(userID: userID9)

      // then
        XCTAssertEqual(guess6, .imageLeft, "KeywordType computed from guess6 is wrong")
        XCTAssertEqual(guess7, .imageLeft, "KeywordType computed from guess7 is wrong")
        XCTAssertEqual(guess8, .imageLeft, "KeywordType computed from guess8 is wrong")
        XCTAssertEqual(guess9, .imageLeft, "KeywordType computed from guess9 is wrong")
    }
}
