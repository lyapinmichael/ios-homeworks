//
//  FeedModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 24.04.2023.
//

import Foundation

enum FeedViewModelNotification {
    static let checkResult = NSNotification.Name("checkResult")
}

protocol FeedViewModelProtocol: AnyObject {
   
    var state: FeedViewModelState { get }
    
    var onStateDidChange: ((FeedViewModelState) -> Void)? { get set }
    
    func updateState(withInput input: FeedViewModelViewInput)
   
}

enum FeedViewModelState {
    case initial
    case didCheckGuess(Bool)
    
}

enum FeedViewModelViewInput {
    case didTapCheckGuessButton(word: String)
}

final class FeedViewModel: FeedViewModelProtocol {
    
    var secretWord = "discombobulate"
    
    var feedView: FeedView?
    
    typealias State = FeedViewModelState
    typealias ViewInput = FeedViewModelViewInput
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    func updateState(withInput input: ViewInput) {
        switch input {
        case .didTapCheckGuessButton(let word):
            check(word)
        }
    }
    
    /// Для того, чтобы протестировать этот метод, но при этом оставить его приватным,
    /// пришлось создать отдельный класс, в котором этот метод является публичным.
    /// Кажется, такое решение соответствует требованию по тестированию в задании, но
    /// выглядит как чудовищный овер-инжиниринг и оттого не кажется оптимальным.
    private func check(_ word: String) {
        
        WordChecker.check(secretWord: secretWord, givenWord: word) { [weak self] checkResult in
            
            self?.state = .didCheckGuess(checkResult)
            
        }
        
    }
}

final class WordChecker {
    
    static func check(secretWord: String, givenWord: String, completion: @escaping ((Bool) -> Void)) {
        
        completion(secretWord == givenWord)
        
    }
    
}
