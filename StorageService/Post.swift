//
//  Post.swift
//  Navigation
//
//  Created by Ляпин Михаил on 11.02.2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct Post: Codable {
    @DocumentID public var id: String?
    public let author: String
    public let authorID: String?
    public let description: String?
    public let likes: Int
    public let hasImageAttached: Bool
    public let dateCreated: Timestamp
    
    
    public init(id: String? = nil, author: String, authorID: String? = nil, description: String?, likes: Int, hasImageAttached: Bool, dateCreated: Date = Date()) {
        self.id = id 
        self.author = author
        self.authorID = authorID
        self.description = description
        self.likes = likes
        self.hasImageAttached = hasImageAttached
        self.dateCreated = Timestamp(date: dateCreated)
    }
    
    public init (id: String, author: String, authorID: String? = nil, description: String?, likes: Int, hasImageAttached: Bool) {
        self.author = author
        self.authorID = authorID
        self.description = description
        self.likes = likes
        self.id = id
        self.hasImageAttached = hasImageAttached
        self.dateCreated = Timestamp(date: Date())
    }
    
    
}
