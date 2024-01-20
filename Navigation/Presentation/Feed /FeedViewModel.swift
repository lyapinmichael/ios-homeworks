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
    
    var postsByDate: [Date: [Post]] { get }
    
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
    
    var postsByDate: [Date: [Post]] = [:] {
        didSet {
            state = .didReceivePosts
        }
    }
    
    var posts: [Post] = [] {
        didSet {
            postsByDate = Dictionary(grouping: posts) { [weak self] post in
                guard let self else { return Date.distantPast }
                let keyComponents = self.calendar.dateComponents([.day, .month, .year], from: post.dateCreated.dateValue())
                var components = DateComponents()
                components.day = keyComponents.day
                components.month = keyComponents.month
                components.year = keyComponents.year
                let date = self.calendar.date(from: components)
                return date ?? Date.distantPast
            }
        }
    }
    
    // MARK: Private properties
    
    private let firestoreService = FirestoreService()
    
    private let calendar = Calendar.current
    
    // MARK: Init
    
    init() {
        fetchAllPosts()
    }
    
    // MARK: Public methods
    
    func updateState(withInput input: ViewInput) {
       
    }
    
    // MARK: Private methods
    
    private func fetchAllPosts() {
        firestoreService.fetchAllPosts { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let posts):
                self.posts = posts.sorted(by: { $0.dateCreated.dateValue() < $1.dateCreated.dateValue() })
            }
        }
    }
}



