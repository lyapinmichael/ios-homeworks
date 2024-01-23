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
    
    var postsByDate:  [(date: Date, posts: [Post])] { get }
    
    var state: FeedViewModel.State { get }
    
    var onStateDidChange: ((FeedViewModel.State) -> Void)? { get set }
    
    func updateState(withInput input: FeedViewModel.ViewInput)
    
}

// MARK: - FeedViewModel

final class FeedViewModel: FeedViewModelProtocol {
 
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
    
    var postsByDate: [(date: Date, posts: [Post])] = [] {
        didSet {
            state = .didReceivePosts
        }
    }
    
    var posts: [Post] = [] {
        didSet {
            postsByDate = groupByDate(posts)
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
    
    private func groupByDate(_ posts: [Post]) -> [(date: Date, posts: [Post])] {
        var groupedPosts: [(date: Date, posts: [Post])] = []
        for post in posts {
            let dateCreated = post.dateCreated.dateValue()
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: dateCreated)
            guard let targetDate = Calendar.current.date(from: dateComponents) else { continue }
            if let groupIndex = groupedPosts.firstIndex(where: { $0.date == targetDate }) {
                groupedPosts[groupIndex].posts.append(post)
            } else {
                groupedPosts.append((targetDate, [post]))
            }
        }
        groupedPosts.sort(by: { $0.date > $1.date } )
        for (index, group) in groupedPosts.enumerated() {
            groupedPosts[index].posts.sort(by: { $0.dateCreated.dateValue() > $1.dateCreated.dateValue() })
        }
        return groupedPosts
    }
    
    // MARK: Types

    enum State {
        case initial
        case didReceivePosts
    }
    
    enum ViewInput {
        case didTapCheckGuessButton(word: String)
    }
    
    
}
