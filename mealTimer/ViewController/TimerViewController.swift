import UIKit
import CoreData

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var mealPickerView: UIPickerView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var timerStartButton: UIButton!
    @IBOutlet var timerResumeButton: UIButton!
    @IBOutlet var timePickerView: UIPickerView!
    @IBOutlet var timerView: UIView!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    
    // pickerview 관련
    let mealCount = [2, 3, 4, 5, 6]
    let hours = Array(0...23)
    let minutes = Array(0...59)
    
    var selectedHour: Int = 0
    var selectedMinute: Int = 0
    var selectedMeal: Int = 0
    
    // 타이머 관련
    var timer: Timer?
    var paused: Bool = false
    var pauseStartTime: Date? // 정지된 시간 기록
    var totalTimeInSeconds: Int = 0
    var mealCountLoop: Int = 2
    
    // 원그리기
    var circularLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIsetup()
        
        // 타이머 원 그리기
        setupCircularLayer()
    }
    
    func UIsetup() {
        mealPickerView.delegate = self
        mealPickerView.dataSource = self
        timePickerView.delegate = self
        timePickerView.dataSource = self
        

        mealPickerView.alpha = 1
        timePickerView.alpha = 0
        
        timerStartButton.isHidden = true
        timerView.alpha = 0
        timerResumeButton.isHidden = true
        
        resetButton.alpha = 0
        pauseButton.alpha = 0
        
        mealPickerView.setValue(UIColor.white, forKey: "textColor")
        timePickerView.setValue(UIColor.white, forKey: "textColor")
        
    }
    
    // 원 그리기 셋업
    func setupCircularLayer() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: timerView.bounds.width / 2, y: timerView.bounds.height / 2),
                                        radius: (timerView.bounds.width - 20) / 2,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
                                        clockwise: true)
        
        circularLayer = CAShapeLayer()
        circularLayer.path = circularPath.cgPath
        circularLayer.strokeColor = UIColor.systemPink.cgColor
        circularLayer.lineWidth = 10
        circularLayer.fillColor = UIColor.clear.cgColor
        circularLayer.lineCap = .round
        circularLayer.strokeEnd = 0
        
        timerView.layer.addSublayer(circularLayer)
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
        
        UIView.animate(withDuration: 0.6) { [weak self] in
                    self?.timePickerView.alpha = 1
                }
        mealPickerView.alpha = 0
        timePickerView.isHidden = false
        
    }
    
    @IBAction func timerStartButtonClicked(_ sender: UIButton) {
        timerStartButton.isHidden = true
        UIView.animate(withDuration: 0.6) { [weak self] in
                    self?.timerView.alpha = 1
                    self?.resetButton.alpha = 1
                    self?.pauseButton.alpha = 1
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
        timerLabel.textColor = .white
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 38)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 추가 레이블 (식사 현황)
        let additionalLabel = UILabel()
        additionalLabel.text = "\(mealCountLoop-1)번째 식사 완료 상태"
        additionalLabel.textColor = .gray
        additionalLabel.textAlignment = .center
        additionalLabel.font = UIFont.systemFont(ofSize: 18)
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
        
        // 일시 정지 버튼 여부확인
        guard !paused else {
            return
        }
        
        // Update circular layer
        let progress = CGFloat(totalTimeInSeconds) / CGFloat((selectedHour * 3600) + (selectedMinute * 60))
        circularLayer.strokeEnd = progress
        
        // 타이머 0초 도달 - 종료 및 남은 끼니수 여부 확인
        if totalTimeInSeconds <= -1 {
            timer?.invalidate()
            removeLabelsFromTimerView()
            timerResumeButton.setTitle("\(mealCountLoop)번째 식사 완료", for: .normal)
            timerResumeButton.isHidden = false
            
            showAlert()
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
    
    // 알람 관련 메서드
    func showAlert() {
        if mealCountLoop <= selectedMeal {
            let alert = UIAlertController(title: "타이머 끝", message: "\(mealCountLoop)번째 식사를 진행하세요", preferredStyle: UIAlertController.Style.alert)
            let okForAlert = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okForAlert)
            present(alert, animated: true)
        } else {                         
            let alert = UIAlertController(title: "오늘의 모든 식사를 끝냈습니다", message: nil, preferredStyle: UIAlertController.Style.alert)
            let okForAlert = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okForAlert)
            present(alert, animated: true)
        }
    }
    
    @IBAction func timerResumeButtonClicked(_ sender: UIButton) {
        mealCountLoop += 1
        timerResumeButton.isHidden = true
        
        UIView.animate(withDuration: 0.6) { [weak self] in
                    self?.timerView.alpha = 1
                }
        
        if mealCountLoop <= selectedMeal {
            print(mealCountLoop)
            timerShow()
        } else {
            showAlert()
            saveData()
            
            timer?.invalidate()
            timerReset()
            
            return
        }
    }
    
    func saveData() {
        // 현재 날짜
        let currentDate = Date()
            
        // 날짜를 문자열로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = dateFormatter.string(from: currentDate)
            
        // Core Data 스택에서 관리 객체 컨텍스트를 가져오기
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // 새로운 Data 객체를 생성
        let entity = NSEntityDescription.entity(forEntityName: "DataControl", in: context)
        let newData = NSManagedObject(entity: entity!, insertInto: context)
        newData.setValue(currentDateString, forKey: "dateString")
        newData.setValue(true, forKey: "value")
        
        // 변경 사항을 저장합니다.
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }


    @IBAction func resetButtonClicked(_ sender: UIButton) {
        timer?.invalidate()
        timerReset()
    }
    
    @IBAction func pauseButtonClicked(_ sender: UIButton) {
        if pauseButton.titleLabel?.text == "정지" {
            paused = true
            pauseStartTime = Date()
            pauseButton.setTitle("재개", for: .normal)
            pauseButton.setTitleColor(UIColor.systemGreen, for: .normal)
        } else {
            // 재개를 하면 멈췄던 시간을 받아 타이머 재가동
            if let pauseStartTime = pauseStartTime {
                let pausedTime = Int(Date().timeIntervalSince(pauseStartTime))
                totalTimeInSeconds += pausedTime
            }
            paused = false
            pauseButton.setTitle("정지", for: .normal)
            pauseButton.setTitleColor(UIColor.systemOrange, for: .normal)
            pauseStartTime = nil  // 멈춰둔 시간 초기화
        }
    }

    
    func timerReset() {
        print("타이머 리셋중")
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timerView.subviews.forEach { $0.removeFromSuperview() }
            self.timerResumeButton.isHidden = true
            self.timerResumeButton.alpha = 1
            self.timerView.alpha = 0
            
            self.mealPickerView.alpha = 1
            self.timePickerView.alpha = 0
            
            self.confirmButton.isHidden = false
            self.timerStartButton.isHidden = true
            
            self.mainLabel.text = "끼니 수 선택"
            self.mainLabel.isHidden = false
            self.mainLabel.alpha = 1
            
            self.mealCountLoop = 2
            self.totalTimeInSeconds = 0
            self.selectedMeal = 0
            self.selectedHour = 0
            self.selectedMinute = 0
            
            // 정지하고 초기화 시켰을 경우 - pauseButton 초기화
            self.paused = false
            self.pauseButton.setTitle("정지", for: .normal)
            self.pauseButton.setTitleColor(UIColor.systemOrange, for: .normal)
            self.pauseStartTime = nil
        }
    }
}
