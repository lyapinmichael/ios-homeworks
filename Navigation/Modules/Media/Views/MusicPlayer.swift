//
//  MusicPlayer.swift
//  Navigation
//
//  Created by Ляпин Михаил on 27.05.2023.
//

import UIKit

protocol MusicPlayerDelegate: AnyObject {
   
    
    func switchPlayPauseButton(_ state:MusicPlayer.PlayPauseButtonState) -> Void
}

class MusicPlayer: UIView {
    
    // MARK: - Embedded enums
    
    enum PlayPauseButtonState {
        case play
        case pause
    }
    
    // MARK: - Public properties
    
    var viewModel: MusicPlayerViewModel?
    
    // MARK: - Private properties
    
    // MARK: UI elements (subviews)
    
    // TODO: Make a progress bar indicating current time position in playing track
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 30
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(nowPlayingLabel)
        stackView.addArrangedSubview(trackNameLabel)
        stackView.addArrangedSubview(artistLabel)
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
        
        stackView.addArrangedSubview(previousButton)
        stackView.addArrangedSubview(playPauseButton)
        stackView.addArrangedSubview(stopButton)
        stackView.addArrangedSubview(nextButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nowPlayingLabel: UILabel = {
        let label = UILabel()
        label.text = "Now playing:"
        label.font = .systemFont(ofSize: 18)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.gray())
        
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        
        let action = UIAction(handler: {_ in
            self.viewModel?.updateState(withInput: .didTapNextButton)
        })
        
        button.addAction(action, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.gray())
        
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        let action = UIAction(handler: {_ in
            self.viewModel?.updateState(withInput: .didTapPreviousButton)
        })
        
        button.addAction(action, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(viewModel: MusicPlayerViewModel?) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
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
                viewModel?.player.play()
                self.trackNameLabel.text = viewModel?.currentTrack.trackName
                self.artistLabel.text = viewModel?.currentTrack.artist
                self.backgroundColor = .systemTeal
            case .pause:
                viewModel?.player.stop()
                self.backgroundColor = .systemOrange
            case .stop:
                self.trackNameLabel.text = nil
                self.artistLabel.text = nil
                viewModel?.player.stop()
                
                viewModel?.player.currentTime = 0
                self.backgroundColor = nil
                
            }
        }
    }
}

extension MusicPlayer: MusicPlayerDelegate {
    func switchPlayPauseButton(_ state: PlayPauseButtonState) {
        switch state {
        case .play:
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .pause:
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    
}
