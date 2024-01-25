//
//  File.swift
//  Navigation
//
//  Created by Ляпин Михаил on 07.01.2024.
//

import UIKit

final class PostAuthorHeaderViewModel: ViewModelProtocol {
        
    // MARK: State related properties
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
     
    var onStateDidChange: ((State) -> Void)?
    
    
    // MARK: Public methods
    
    func updateState(with viewInput: ViewInput) {
        switch viewInput {
        case .requestAvatar(let authorID):
            return
        }
    }
    
    // MARK: Private methods
    
    private func fetchAvatarForAuthor(_ authorID: String) {
        if let cachedImageData = try? LocalStorageService.default.readUserAvatarCache(from: authorID),
           let cachedImage = UIImage(data: cachedImageData) {
            self.state = .didReceiveAuthorsAvatar(cachedImage)
        } else {
            CloudStorageService.shared.downloadAvatar(forUser: authorID) { [weak self] imageData, _ in
                if let imageData,
                   let image = UIImage(data: imageData) {
                    try? LocalStorageService.default.writeUserAvatarCache(userID: authorID, jpegData: imageData)
                    self?.state = .didReceiveAuthorsAvatar(image)
                }
            }
        }
    }
    
    // MARK: Types
    
    enum State {
        case initial
        case didReceiveAuthorsAvatar(UIImage)
    }
    
    enum ViewInput {
        case requestAvatar(authorID: String)
    }

    
}
