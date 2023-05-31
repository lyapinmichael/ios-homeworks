//
//  RecorderViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 30.05.2023.
//

import Foundation
import AVFoundation

protocol RecorderViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((RecorderViewModel.State) -> Void)? { get set }
    var recorder: AVAudioRecorder? { get }
    var audioPlayer: AVAudioPlayer? { get }
    var audioSession: AVAudioSession? { get }
    func updateState(withInput input: RecorderViewModel.ViewInput)

}

// TODO: enhance viewmodel protocol;
// TODO: combine recorderviewmodel and player viewmodel into one class, based more on recorderVM
// TODO: enhance recorder view delegate protocol and music player view delegate protocol and combine them into one

class RecorderViewModel: RecorderViewModelProtocol {
    
    // MARK: Embedded enums
    
    enum State {
        case initial
        case record
        case play
        case pause
        case stop
    }
    
    enum ViewInput {
        case didTapRecordButton
        case didTapPlayPauseButton
        case didTapStopButton
    }
    
    // MARK: - Public properties
    
    weak var delegate: RecorderViewDelegate?
    
    private(set) var state: State = .initial {
        didSet{
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    var recorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioSession: AVAudioSession? = AVAudioSession.sharedInstance()
    
    // MARK: Public methods
    
    func updateState(withInput input: ViewInput) {
        switch input{
        case .didTapPlayPauseButton:
            guard state != .play else {
                state = .pause
                audioPlayer?.stop()
                return
            }
            state = .play
            audioPlayer?.play()
        
            
        case .didTapRecordButton:
            guard state != .record else {
                state = .stop
                stopRecording()
                return
            }
            
            guard prepareAudioSession() else {
                return
            }
            
            state = .record
            startRecording()

            
            
        case .didTapStopButton:
            state = .stop
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0
        }
    }
    
    // MARK: - Private methods
    
   private func prepareAudioSession() -> Bool {
       print("preparing audio session...")
       
       var permissionGranted: Bool = false
       
       do {
            try audioSession?.setCategory(.playAndRecord, mode: .default)
            try audioSession?.setActive(true)
            
            audioSession?.requestRecordPermission() { [unowned self] allowed in
                permissionGranted = allowed
                DispatchQueue.main.async {
                    if allowed {
                        print("Recording allowed")
                        self.delegate?.toggleRecordButton(.recording)

                    } else {
                        print("Recording prohibited")
                    }
                }
                
            }
        } catch {
            print(error)
        }
       
       return permissionGranted
    }
    
    private  func startRecording() {
        
        do {
            
           let url = getRecordingFileURL()
            
            let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
                ]
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.prepareToRecord()
            recorder?.record()
            print("recording")
            
        } catch {
            print (error)
            assertionFailure("Something went wrong while recording")
            
        }
    }
    
    private func stopRecording() {
        recorder?.stop()
        print("recording stopped")
        recorder = nil
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: getRecordingFileURL())
            audioPlayer?.prepareToPlay()
        } catch {
            print(error)
            assertionFailure("Failed to create audioPlayer and prepare it to play")
        }
    }
    
    private func getRecordingFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("recording", conformingTo: .mpeg)
    }
}
