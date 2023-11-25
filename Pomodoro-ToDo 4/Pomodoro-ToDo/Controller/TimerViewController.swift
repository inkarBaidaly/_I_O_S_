import UIKit

class TimerViewController: UIViewController, SegmentedControlDelegate {
    
    enum State {
        case invalidate
        case progress
        case pause
    }
    
    private var state: State = .invalidate
    private weak var timer: Timer?
    private var timeLeft: Int = 300
    private var _timeLeft: String {
        return String(format: "%02d:%02d", timeLeft / 60, timeLeft % 60)
    }
    private let timeList: [Int] = [300, 1500, 900]
    private var selectedRow: Int = 0

    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        picker.tintColor = .black
        picker.setValue(UIColor.black, forKey: "textColor")
        return picker
    }()
    
    private let segControl: SegmentedControl = {
        let segControl = SegmentedControl(
            frame: CGRect(x: 50, y: 170, width: 280, height: 50),
            buttonTitle: ["Short Break","Work","Long Break"])
        segControl.textColor = .lightGray
        segControl.selectorTextColor = .black
        return segControl
    }()

    private let timerCirclePathView = TimerCirclePathView()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(
            ofSize: 48,
            weight: .bold
        )
        label.textColor = .black
        label.text = _timeLeft
        return label
    }()

    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.addTarget(
            self,
            action: #selector(didTapStartButton(_:)),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "clock.arrow.2.circlepath"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.addTarget(
            self,
            action: #selector(didTapResetButton(_:)),
            for: .touchUpInside
        )
        return button
    }()
    
    func segSelectedIndexChange(to index: Int) {
         switch index {
         case 0: print("Short Break")
         case 1: print("Work")
         case 2: print("Long Break")
         default: break
         }
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayoutConstraints()
        timerCirclePathView.configureCirclePath(
            center: CGPoint(
                x: 200,
                y: 200
            ),
            radius: 150,
            startAngle: 0,
            endAngle: 2 * .pi
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(segControl)
        segControl.delegate = self
        startButton.layer.cornerRadius = startButton.frame.size.height / 2
        resetButton.layer.cornerRadius = resetButton.frame.size.height / 2
    }

    private func initTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(fireTimer),
            userInfo: nil,
            repeats: true
        )
        guard let timer = timer else { return }
        timer.tolerance = 0.15
        RunLoop.current.add(timer, forMode: .common)
    }
    
    private func setupLayoutConstraints() {

        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            pickerView.heightAnchor.constraint(equalToConstant: 100)
        ])

        timerCirclePathView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerCirclePathView)
        NSLayoutConstraint.activate([
            timerCirclePathView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerCirclePathView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timerCirclePathView.widthAnchor.constraint(equalToConstant: 400),
            timerCirclePathView.heightAnchor.constraint(equalToConstant: 400)
        ])

        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerCirclePathView.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: timerCirclePathView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerCirclePathView.centerYAnchor)
        ])

        let hStack = UIStackView(arrangedSubviews: [resetButton, startButton])
        hStack.axis = .horizontal
        hStack.spacing = 32
        hStack.alignment = .fill
        hStack.distribution = .fillEqually
        hStack.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: timerCirclePathView.bottomAnchor, constant: 32),
            hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 60),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            resetButton.widthAnchor.constraint(equalToConstant: 60),
            resetButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func updateUI(state: State) {
        switch state {
        case .invalidate, .pause:
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            startButton.backgroundColor = .systemGreen
        case .progress:
            startButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            startButton.backgroundColor = .systemBlue
        }
    }

}

extension TimerViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(timeList[row] / 60) min"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        timeLeft = timeList[selectedRow]
        state = .invalidate
        updateUI(state: state)
        timerLabel.text = _timeLeft
        timerCirclePathView.resetAnimation()
    }
}

extension TimerViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeList.count
    }
}

@objc
private extension TimerViewController {
    func fireTimer() {
        timeLeft -= 1
        timerLabel.text = _timeLeft
        if timeLeft <= 0 {
            state = .invalidate
            timer?.invalidate()
            timer = nil
            updateUI(state: state)
            timeLeft = timeList[selectedRow]
            timerCirclePathView.resetAnimation()
        }
    }

    func didTapStartButton(_ sender: UIButton) {
        switch state {
        case .invalidate:
            state = .progress
            updateUI(state: state)
            //timer start
            initTimer()
            timerCirclePathView.startAnimation(Double(timeLeft))
        case .pause:
            state = .progress
            updateUI(state: state)
            //timer restart
            initTimer()
            timerCirclePathView.resumeAnimation()
        case .progress:
            state = .pause
            updateUI(state: state)
            //timer stop
            guard let timer = timer else { return }
            timer.invalidate()
            timerCirclePathView.pauseAnimation()
        }
    }

    func didTapResetButton(_ sender: UIButton) {
        state = .invalidate
        timerCirclePathView.resetAnimation()
        updateUI(state: state)
        timeLeft = timeList[selectedRow]
        timerLabel.text = _timeLeft

        guard let timer = timer else { return }
        timer.invalidate()
    }

}
