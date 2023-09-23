//
//  FeedViewControllerTests.swift
//  NavigationTests
//
//  Created by Ляпин Михаил on 20.09.2023.
//

import Foundation
import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {
    
    /// Два теста ниже используют инстанс непосредственно класса FeedViewModel()
    func testCheckGuess1() {
        let feedViewModel = FeedViewModel()

        let testWord = "someTestWord"
        
        feedViewModel.updateState(withInput: .didTapCheckGuessButton(word: testWord))
        
        if case .didCheckGuess(let flag) = feedViewModel.state {
            XCTAssertFalse(flag)
        } else {
            XCTFail()
        }

    }
    
    
    func testCheckGuess2() {
        let feedViewModel = FeedViewModel()

        let testWord = "discombobulate"
        
        feedViewModel.updateState(withInput: .didTapCheckGuessButton(word: testWord))
        
        if case .didCheckGuess(let flag) = feedViewModel.state {
            XCTAssertTrue(flag)
        } else {
            XCTFail()
        }

    }
    
    /// Эти же два теста использует mock-класс, закрытый протоколом, как описано в задании.
    func testAlternativeCheckGuess1() {
        
        let feedViewModel = FeedViewModelMock()
        
        feedViewModel.onStateDidChange = { viewInput in
            if case .didCheckGuess(let checkResult) = viewInput {
                
                XCTAssertTrue(checkResult)
            }
        }
        
        feedViewModel.updateState(withInput: .didTapCheckGuessButton(word: "pollution"))
        
    }
    
    func testAlternativeCheckGuess2() {
        
        let feedViewModel = FeedViewModelMock()
        
        feedViewModel.onStateDidChange = { viewInput in
            if case .didCheckGuess(let checkResult) = viewInput {
                
                XCTAssertFalse(checkResult)
            }
        }
        
        feedViewModel.updateState(withInput: .didTapCheckGuessButton(word: "wrongWord"))
        
    }
    
}

fileprivate final class FeedViewModelMock: FeedViewModelProtocol {
   
    var secretWord = "pollution"
    
    var state: Navigation.FeedViewModelState = .initial {
        didSet{
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((Navigation.FeedViewModelState) -> Void)?
    
    func updateState(withInput input: Navigation.FeedViewModelViewInput) {
        
        if case .didTapCheckGuessButton(let word) = input {
            WordChecker.check(secretWord: secretWord, givenWord: word) { [weak self] checkResult in
                
                self?.state = .didCheckGuess(checkResult)
                
            }
        }
        
    }
    
    
}
