import UIKit

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var mealPickerView: UIPickerView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var timerStartButton: UIButton!
    @IBOutlet var timerResumeButton: UIButton!
    @IBOutlet var timePickerView: UIPickerView!
    @IBOutlet var timerView: UIView!
    
    // pickerview 관련
    let mealCount = [2, 3, 4, 5, 6]
    let hours = Array(0...23)
    let minutes = Array(0...59)
    
    var selectedHour: Int = 0
    var selectedMinute: Int = 0
    var selectedMeal: Int = 0
    
    // 타이머 관련
    var timer: Timer?
    var totalTimeInSeconds: Int = 0
    var mealCountLoop: Int = 2

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealPickerView.delegate = self
        mealPickerView.dataSource = self
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        timePickerView.isHidden = true
        timerStartButton.isHidden = true
        timerView.alpha = 0
        timerResumeButton.isHidden = true
   
    }
    
    // PickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == mealPickerView {
            return 1
        } else if pickerView == timePickerView {
            return 2
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == mealPickerView {
            return mealCount.count
        } else if pickerView == timePickerView {
            return component == 0 ? hours.count : minutes.count
        }
        return 0
    }
    
    // PickerView Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mealPickerView {
            return "\(mealCount[row])"
        } else if pickerView == timePickerView {
            return component == 0 ? "\(hours[row]) 시간" : "\(minutes[row]) 분"
        }
        return nil
    }
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        selectedMeal = mealCount[mealPickerView.selectedRow(inComponent: 0)]    // mealPickerView
        selectedHour = hours[timePickerView.selectedRow(inComponent: 0)]        // timePickerView
        selectedMinute = minutes[timePickerView.selectedRow(inComponent: 1)]    // timePickerView
        
        mainLabel.text = "식사 간격 시간 선택"
        confirmButton.isHidden = true
        timerStartButton.isHidden = false
        
        mealPickerView.isHidden = true
        timePickerView.isHidden = false
    }
    
    @IBAction func timerStartButtonClicked(_ sender: UIButton) {
        timerStartButton.isHidden = true
        UIView.animate(withDuration: 0.6) { [weak self] in
                    self?.timerView.alpha = 1
                }
        timePickerView.isHidden = true
        mainLabel.isHidden = true
        
        timerShow()
    }
    
    // 타이머 화면에 등장
    func timerShow(){
        
        // 기존의 레이블이 이미 추가되어 있다면 삭제
        timerView.subviews.forEach { $0.removeFromSuperview() }
        
        timerLabelSetup()
        
        startTimer()
    }
    
    // 타이머에 표시될 레이블
    func timerLabelSetup() {
        // 타이머 레이블
        let timerLabel = UILabel()
        timerLabel.text = remainingTimeText(totalTimeInSeconds)
        timerLabel.textColor = .black
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 36)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 추가 레이블 (식사 현황)
        let additionalLabel = UILabel()
        additionalLabel.text = "\(mealCountLoop-1)번째 식사 완료 상태"
        additionalLabel.textColor = .gray
        additionalLabel.textAlignment = .center
        additionalLabel.font = UIFont.systemFont(ofSize: 16)
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timerView.addSubview(timerLabel)
        timerView.addSubview(additionalLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor, constant: -20),
            
            additionalLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
            additionalLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor)
        ])
        
    }
    
    // 타이머 남은 시간 레이블형식 전환
    func remainingTimeText(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func startTimer() {
        totalTimeInSeconds = (selectedHour * 3600) + (selectedMinute * 60)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimer() {
        totalTimeInSeconds -= 1
        
        // 타이머 0초 도달 - 종료 및 남은 끼니수 여부 확인
        if totalTimeInSeconds <= -1 {
            timer?.invalidate()
            removeLabelsFromTimerView()
            timerResumeButton.setTitle("\(mealCountLoop)번째 식사 완료", for: .normal)
            timerResumeButton.isHidden = false
        } else {
            if let timerLabel = timerView.subviews.first as? UILabel {
                timerLabel.text = remainingTimeText(totalTimeInSeconds)
            }
        }
    }
    
    // 타이머 뷰에 있는 서브 뷰(레이블) 제거
    func removeLabelsFromTimerView() {
        timerView.subviews.forEach { subview in
            if subview is UILabel {
                subview.removeFromSuperview()
            }
        }
    }
    
    @IBAction func timerResumeButtonClicked(_ sender: UIButton) {
        mealCountLoop += 1
        timerResumeButton.isHidden = true
        
        UIView.animate(withDuration: 0.6) { [weak self] in
                    self?.timerView.alpha = 1
                }
//        timerView.isHidden = false
        
        
        if mealCountLoop <= selectedMeal {
            print(mealCountLoop)
            timerShow()
        } else {
            timer?.invalidate()
            timerReset()
            
            // 하루 식단 사이클 완료시 date에 표시
            dateCheck()
            return
        }
    }
    
    func dateCheck(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let current_date = dateFormatter.string(from: Date())
        
    }
    
    func timerReset() {
        print("타이머 리셋중")
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timerView.subviews.forEach { $0.removeFromSuperview() }
            self.timerResumeButton.isHidden = true
            self.timerResumeButton.alpha = 1  // Reset alpha if modified
            self.timerView.alpha = 0
            self.mealPickerView.isHidden = false
            self.confirmButton.isHidden = false
            self.mainLabel.text = "끼니 수 선택"
            self.mainLabel.isHidden = false
            self.mainLabel.alpha = 1
            self.timePickerView.isHidden = true
            self.timerStartButton.isHidden = true
            self.mealCountLoop = 2
            self.totalTimeInSeconds = 0
            self.selectedMeal = 0
            self.selectedHour = 0
            self.selectedMinute = 0
        }
    }
}
