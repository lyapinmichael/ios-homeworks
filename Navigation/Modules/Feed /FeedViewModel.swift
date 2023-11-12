//
//  FeedModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 24.04.2023.
//

import Foundation
import StorageService

// MARK: - FeedViewModel Protocol

protocol FeedViewModelProtocol: AnyObject {
    
    var posts: [Post] { get }
    
    var state: FeedViewModel.State { get }
    
    var onStateDidChange: ((FeedViewModel.State) -> Void)? { get set }
    
    func updateState(withInput input: FeedViewModel.ViewInput)
    
}

// MARK: - FeedViewModel

final class FeedViewModel: FeedViewModelProtocol {
    
    enum State {
        case initial
        case didReceivePosts
    }
    
    enum ViewInput {
        case didTapCheckGuessButton(word: String)
    }
    
    // MARK: Feed view
    
    weak var feedView: FeedView?
    
    // MARK: State related properties
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: Public properties
    
    var posts: [Post] = [] {
        didSet {
            state = .didReceivePosts
        }
    }
    
    // MARK: Private properties
    
    private let firestoreService = FirestoreService()
    
    init() {
        fetchAllPosts()
    }
    
    // MARK: Public methods
    
    func updateState(withInput input: ViewInput) {
        switch input {
        case .didTapCheckGuessButton(let word):
            return
        }
    }
    
    // MARK: Private methods
    
    private func fetchAllPosts() {
        firestoreService.fetchAllPosts { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let posts):
                self.posts = posts
            }
        }
    }
}



