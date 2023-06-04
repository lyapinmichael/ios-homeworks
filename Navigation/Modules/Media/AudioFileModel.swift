//
//  AudioFileModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.05.2023.
//

import Foundation

struct AudioFile {
    let pathToFile: String
    let trackName: String
    let artist: String?
    
    static func makeArray() -> [Self] {
        return [
            AudioFile(pathToFile: Bundle.main.path(forResource: "allthat", ofType: "mp3")!,
                      trackName: "All That",
                      artist: "Benjamin Tissot"),
            AudioFile(pathToFile: Bundle.main.path(forResource: "photoalbum", ofType: "mp3")!,
                      trackName: "Photo Album",
                      artist: "Benjamin Tissot"),
            AudioFile(pathToFile: Bundle.main.path(forResource: "creativeminds", ofType: "mp3")!,
                      trackName: "Creative minds",
                      artist: "Benjamin Tissot"),
            AudioFile(pathToFile: Bundle.main.path(forResource: "jazzyfrenchy", ofType: "mp3")!,
                      trackName: "Jazzy Frenchy",
                      artist: "Benjamin Tissot"),
            AudioFile(pathToFile: Bundle.main.path(forResource: "dreams", ofType: "mp3")!,
                      trackName: "Dreams",
                      artist: "Benjamin Tissot")
        ]
    }
}
