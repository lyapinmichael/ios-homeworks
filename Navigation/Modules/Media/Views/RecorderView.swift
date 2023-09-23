//
//  Recorder.swift
//  Navigation
//
//  Created by Ляпин Михаил on 30.05.2023.
//

import UIKit

protocol RecorderViewDelegate: AnyObject {
    
    func togglePlayPauseButton(_ state: RecorderView.PlayPauseButtonState)
    func toggleRecordButton(_ state: RecorderView.RecordButtonState)
  
    
}

class RecorderView: UIView {
  
    
    
    // MARK: Embedden enums
    
    enum PlayPauseButtonState {
        case play
        case pause
    }

    enum RecordButtonState {
        case normal
        case recording
    }
    
    // MARK: Public properties
    
    var viewModel: RecorderViewModel?
    
    // MARK: Private properties
    
    private lazy var mainStack: UIStackView = {
       let stackView = UIStackView()
        stackView.backgroundColor = Palette.dynamicBars
        stackView.layer.cornerRadius = 30
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 25
        
        stackView.addArrangedSubview(buttonsStack)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 25
        
        stackView.addArrangedSubview(recordButton)
        stackView.addArrangedSubview(playPauseButton)
        stackView.addArrangedSubview(stopButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var playPauseButton: UIButton = {
        
        let button = UIButton(configuration: UIButton.Configuration.gray())
        
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        let action = UIAction(handler: {_ in
            self.viewModel?.updateState(withInput: .didTapPlayPauseButton)
        })
        
        button.addAction(action, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.gray())
        
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        
        let action = UIAction(handler: {_ in
            self.viewModel?.updateState(withInput: .didTapStopButton)
        })
        
        button.addAction(action, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var recordButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.gray())
        
        button.setImage(UIImage(systemName: "record.circle"), for: .normal)
        
        let action = UIAction(handler: {_ in
            self.viewModel?.updateState(withInput: .didTapRecordButton)
        })
        
        button.addAction(action, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    
    init(viewModel: RecorderViewModel?) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        bindViewModel()
        addSubview(mainStack)
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
        ])
    }
    
    private func bindViewModel() {
        viewModel?.onStateDidChange = { [weak self] state in
            guard let self = self else {
                assertionFailure("Bad self binding")
                return
            }
            
            switch state {
            case .initial:
                return
            
            case .play:
                togglePlayPauseButton(.play)
                
            case .pause:
                togglePlayPauseButton(.pause)
                
            case .record:
                self.toggleRecordButton(.recording)
                self.trasportButtonsAreEnabled(false)
                
                
            case .stop:
                self.trasportButtonsAreEnabled(true)
                self.togglePlayPauseButton(.pause)
                self.toggleRecordButton(.normal)
            }
        }
    }
    
    private func trasportButtonsAreEnabled(_ value: Bool) {
        switch value {
        case true:
            self.playPauseButton.isEnabled = true
            self.stopButton.isEnabled = true
        case false:
            self.stopButton.isEnabled = false
            self.playPauseButton.isEnabled = false
        }
        
    }
    
}

extension RecorderView: RecorderViewDelegate {
    func togglePlayPauseButton(_ state: PlayPauseButtonState) {
        switch state {
        case .play:
            self.playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .pause:
            self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func toggleRecordButton(_ state: RecordButtonState) {
        switch state {
        case .recording:
            self.recordButton.setImage(UIImage(systemName: "record.circle.fill"), for: .normal)
            self.recordButton.tintColor = .red
        case .normal:
            self.recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
            self.recordButton.tintColor = nil
        }
    }
}
