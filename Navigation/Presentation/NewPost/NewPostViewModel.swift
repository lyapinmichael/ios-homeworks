//
//  NewPostViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 22.01.2024.
//

import UIKit
import StorageService

final class NewPostViewModel {
    
    // MARK: Private properties
    
    private let firestoreService = FirestoreService()
    
    private let repository: ProfileRepository
    private let user: User
    private var text: String = ""
    private var image: UIImage?
    
    // MARK: State related properties
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: Init
    
    init(repository: ProfileRepository) {
        self.user = repository.profileData.value
        self.repository = repository
    }
    
    // MARK: Public methods
    
    func updateState(with viewInput: ViewInput) {
        switch viewInput {
        case .didChangeText(let text):
            self.text = text
            state = .initial
        case .didPickImage(let image):
            self.image = image
            state = .initial
        case .didTapUploadButton:
            state = .tyringToUpload
            uploadPost()
        }
    }
    
    // MARK: Private methods
    
    private func uploadPost() {
        var post = Post(author: user.fullName,
                        authorID: user.id,
                        description: text,
                        likes: 0,
                        hasImageAttached: image != nil)
        firestoreService.writeNewPost(&post) { [weak self] result in
            switch result {
            case .success(let post):
                self?.repository.postData.value.append(post)
//                print(self?.repository.postData.value)
                self?.state = .didUpload
                self?.uploadPostImageIfNeeded(post)
            case .failure(let error):
                print(error)
                self?.state = .failedToUpload
            }
        }
    }
    
    private func uploadPostImageIfNeeded(_ post: Post) {
        guard let postID = post.id,
              let image,
              post.hasImageAttached else { return }
        CloudStorageService.shared.uploadImage(image, forPost: postID) { error in
            if let error {
                print(error)
            }
        }
    }
    
    // MARK: Types
    
    enum State {
        case initial
        case tyringToUpload
        case failedToUpload
        case didUpload
    }
    
    enum ViewInput {
        case didTapUploadButton
        case didChangeText(String)
        case didPickImage(UIImage)
    }
}
