//
//  MediaViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 28.05.2023.
//

import Foundation
import AVFoundation

protocol MusicPlayerViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((MusicPlayerViewModel.State) -> Void)? { get set }
    
    func updateState(withInput input: MusicPlayerViewModel.ViewInput)

    var player: AVAudioPlayer { get }
    
    func prepareToPlay(_ track: AudioFile)
}

class MusicPlayerViewModel: MusicPlayerViewModelProtocol {
    
    // MARK: - Embedded enums
    enum State {
        case initial
        case play
        case pause
        case stop
    }
    
    enum ViewInput {
        case didTapPlayPauseButton
        case didTapStopButton
        case didTapNextButton
        case didTapPreviousButton
    }
    
    // MARK: - Public properties
    
    weak var delegate: MusicPlayerDelegate?
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    var onStateDidChange: ((State) -> Void)?
    
    var player: AVAudioPlayer = AVAudioPlayer()
    var tracksArray: [AudioFile]
    var currentTrack: AudioFile
    
    // MARK: - Init
    
    init() {
       self.tracksArray = AudioFile.makeArray()
       self.currentTrack = tracksArray[0]
       prepareToPlay(self.currentTrack)
       
   }

    
    // MARK: - Public methods
    
    func updateState(withInput input: ViewInput) {
        switch input {
        case .didTapPlayPauseButton:
            if case .play = state {
                state = .pause
                delegate?.switchPlayPauseButton(.pause)
            } else {
                state = .play
                delegate?.switchPlayPauseButton(.play)
            }
        
        case .didTapStopButton:
            guard state != .stop else { return }
            state = .stop
            delegate?.switchPlayPauseButton(.pause)
            
        case .didTapNextButton:
            
            guard state != .stop else { return }
            
            let tracksCount = tracksArray.count
            
            guard tracksCount > 0 else {
                state = .play
                return
            }
            
            guard let currentIndex = tracksArray.firstIndex(where: {$0.pathToFile == currentTrack.pathToFile}) else {
                assertionFailure("bad path to track: current track seems not to exist")
                return
            }
            
           
            if currentIndex < tracksCount - 1 {
                self.currentTrack = tracksArray[currentIndex + 1]
                prepareToPlay(self.currentTrack)
            } else {
                self.currentTrack = tracksArray[0]
                prepareToPlay(tracksArray[0])
            }
            
            if case .play = state {
                state = .play
                delegate?.switchPlayPauseButton(.play)
            }
            
            if case .pause = state {
                state = .play
                delegate?.switchPlayPauseButton(.play)
            }
            
            
            
        case .didTapPreviousButton:
            
            if case .stop = state {
                return
            }
            
            let tracksCount = tracksArray.count
            
            guard tracksCount > 0 else {
                state = .play
                return
            }
            
            guard let currentIndex = tracksArray.firstIndex(where: {$0.pathToFile == currentTrack.pathToFile}) else {
                assertionFailure("bad path to track: current track seems not to exist")
                return
            }
            
           
            if currentIndex > 0 {
                self.currentTrack = tracksArray[currentIndex - 1]
                prepareToPlay(self.currentTrack)
            } else {
                self.currentTrack = tracksArray.last!
                prepareToPlay(self.currentTrack)
            }
            
            if case .play = state {
                state = .play
            }
            
            if case .pause = state {
                state = .play
            }
        }
    }
    
    func prepareToPlay(_ track: AudioFile) {
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(filePath: track.pathToFile))
            player.prepareToPlay()
        } catch {
            print(error)
        }
    }
}

