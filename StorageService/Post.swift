//
//  Post.swift
//  Navigation
//
//  Created by Ляпин Михаил on 11.02.2023.
//

import Foundation

public struct Post: Codable {
    public let title: String
    public let author: String
    public let description: String?
    public let imageURL: String?
    public let likes: Int
    public let views: Int
    public let id: String
    
    public init(title: String, author: String, description: String?, image: String?, likes: Int, views: Int) {
        self.title = title
        self.author = author
        self.description = description
        self.imageURL = image
        self.likes = likes
        self.views = views
        self.id = UUID().uuidString
    }
    
    private init (title: String, author: String, description: String?, image: String?, likes: Int, views: Int, id: String) {
        self.title = title
        self.author = author
        self.description = description
        self.imageURL = image
        self.likes = likes
        self.views = views
        self.id = id
    }
}

public extension Post {
    
    static func make() -> [Post] {
        [
            Post(
                title: "If this is a consular ship, where is the ambassador?",
                author: "Darth Vader",
                description: nil,
                image: "CorellianCorvette",
                likes: 90,
                views: 887,
                id: "demoPostID1"),
            
            Post(
                title: "My yonger self thoughts were wise...",
                author: "Darth Vader",
                description: "I remember back then, Padme and I were enjoying ourselves on Nabu, and I then told her:  We need a system where the politicians sit down and discuss the problem, agree what’s in the best interest of all the people and then do it. Time has run since then, but no such a political instance was ever created. Sadly.",
                image: nil,
                likes: 57,
                views: 729,
                id: "demoPostID2"),
            
            Post(
                title: "Our masterpiece WIP",
                author: "Darth Vader",
                description: nil,
                image: "DeathStarWIP",
                likes: 117, views: 1492,
                id: "demoPostID3"),
            
            Post(
                title: "My thought on Endor affair, tldr;",
                author: "Darth Vader",
                description: "I stand upon the soil of Endor, a planet overflowing with life, yet the deathly presence of the Dark Side looms above.  As a Sith Lord, it is my duty to uphold the will of the Empire, but my true purpose is to impart the philosophy of the Dark Side, the balance between existence and destruction.\nEndor teems with life and vitality, yet it must be tempered with the act of destruction. Only through the lens of destruction and the embrace of the Dark Side can life flourish. The cycle of life and death must continue to feed one another lest stagnation and weakness take hold.\nThe plight of the Ewoks serves as an illustration of this important principle. The Empire seeks to harness their world for its resources and to achieve control over its people. The Rebels seek to liberate them without comprehending the power of destruction. Both paths are fraught with weakness and failure.\nOnly through the understanding and acceptance of the Dark Side can the true potential of life be realized. The Ewoks must be made to understand this. They must come to see the strengths of the Empire and how our methods benefit all life.\nOn Endor, I do not see a primitive planet, but instead, a galaxy of untapped resources and strength. By embracing the power of the Dark Side, we can rule together, for the benefit of all creatures.",
                image: "DarthVaderOnEndor",
                likes: 1097,
                views: 7823,
                id: "demoPostID4"),
            
            Post(
                title: "BTW last post was generated by ChatGPT",
                author: "Darth Vader",
                description: nil,
                image: nil,
                likes: 781,
                views: 6995,
                id: "demoPostID5"),
            
            Post(title: "reposted from Master Yoda",
                 author: "Master Yoda",
                 description: "Pass on what you have learned. Strength, mastery, hmm… but weakness, folly, failure, also. Yes, failure, most of all. The greatest teacher, failure is.",
                 image: "MasterYoda", likes: 567,
                 views: 1092,
                 id: "demoPostID6")
        
        ]
    }
    
}
