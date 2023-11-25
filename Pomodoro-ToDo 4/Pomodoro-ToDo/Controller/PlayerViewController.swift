import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAudio()
    }

    func loadAudio() {
        if let path = Bundle.main.path(forResource: "once-in-paris-168895", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)

                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.prepareToPlay()
                } catch {
                    print("Error loading audio file: \(error.localizedDescription)")
                }
            }
        }

    lazy var constantHeight1 = 74.0
    private let musicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .gray.withAlphaComponent(0.58)
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Once in Paris"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.layer.cornerRadius = 42
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .red
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .red
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        return button
    }()
    
    private lazy var durationSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        slider.tintColor = .red
        slider.thumbTintColor = .red
        return slider
    }()
    
    private lazy var sliderCurrentValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var sliderMaximumValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "01:00"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    

    
    func setupUI() {
        view.frame = CGRect(x: 0, y: self.view.frame.height - (constantHeight1 + 82), width: self.view.frame.width, height: constantHeight1)
        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        
        view.addSubview(musicImageView)
        musicImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            musicImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            musicImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            musicImageView.widthAnchor.constraint(equalToConstant: 350),
            musicImageView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        if let image = UIImage(named: "Image") {
            musicImageView.image = image
        } else {
            print("Image not found")
        }
        
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: musicImageView.bottomAnchor, constant: 150),
            playButton.widthAnchor.constraint(equalToConstant: 150),
            playButton.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 20),
            nextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 25),
            nextButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -20),
            backButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        view.addSubview(durationSlider)
        view.addSubview(sliderCurrentValueLabel)
        view.addSubview(sliderMaximumValueLabel)
        durationSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            durationSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            durationSlider.topAnchor.constraint(equalTo: musicImageView.bottomAnchor, constant: 50),
            durationSlider.widthAnchor.constraint(equalTo: musicImageView.widthAnchor),
            durationSlider.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        sliderCurrentValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderCurrentValueLabel.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 5),
            sliderCurrentValueLabel.leadingAnchor.constraint(equalTo: durationSlider.leadingAnchor),
        ])

        sliderMaximumValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderMaximumValueLabel.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 5),
            sliderMaximumValueLabel.trailingAnchor.constraint(equalTo: durationSlider.trailingAnchor),
        ])
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: musicImageView.bottomAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalTo: musicImageView.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        view.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: durationSlider.leadingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(shareButton)
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            shareButton.widthAnchor.constraint(equalToConstant: 40),
            shareButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
    }
    
    
    private var isPlaying = false
    
    @objc func playButtonTapped() {
        isPlaying.toggle()
        updatePlayButtonImage()
        updateMusicImageSize()
        guard let player = audioPlayer else {
            return
        }
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        } else {
            player.play()
        }
        UIView.animate(withDuration: 0.6) {
            let rotationTransform = self.isPlaying ? CGAffineTransform(rotationAngle: .pi) : CGAffineTransform.identity
            self.playButton.transform = rotationTransform
        }
        func updatePlayButtonImage() {
            let imageName = isPlaying ? "pause.fill" : "play.fill"
            playButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
        
        func updateMusicImageSize() {
            let scale: CGFloat = isPlaying ? 1.0 : 0.70
            UIView.animate(withDuration: 0.3) {
                self.musicImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }

    @objc func likeButtonTapped() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.backgroundColor = .systemPink
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: { [weak self] in
                self?.view.backgroundColor = .white
            }, completion: nil)
        }
    }
}
