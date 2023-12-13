import UIKit

class FoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var foodItems = [FoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // JSON 데이터를 Bundle에서 가져와 디코딩
        if let path = Bundle.main.path(forResource: "foodData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                self.foodItems = try decoder.decode([FoodItem].self, from: data)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        // TableView 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        // FoodCell 클래스를 등록하고, 스타일을 subtitle로 설정
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FoodCell")
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        
        cell.textLabel?.text = foodItems[indexPath.row].식품이름
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // 셀 background
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 셀의 detailTextLabel의 텍스트를 가져옴
        let selectedFoodDetail = foodItems[indexPath.row]
        
        // 새로운 VC 생성 - sheetView
        let foodDetailVC = UIViewController()
        foodDetailVC.view.backgroundColor = UIColor(named: "sheetColor")
        
        // Stack View에 제목, 레이블 추가
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10

        let titleLabel = UILabel()
        titleLabel.textColor = .systemPink
        titleLabel.text = "\(selectedFoodDetail.식품이름)"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        stackView.addArrangedSubview(titleLabel)

        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
            기준함량 : \(selectedFoodDetail.기준함량)
            열량 : \(selectedFoodDetail.열량) kcal
            탄수화물 : \(selectedFoodDetail.탄수화물) g
            단백질 : \(selectedFoodDetail.단백질) g
            지방 : \(selectedFoodDetail.지방) g
            """
        label.textAlignment = .center
        label.textColor = UIColor(named: "sheetTextColor")
        label.font = UIFont.systemFont(ofSize: 24)
        stackView.addArrangedSubview(label)
        
        stackView.setCustomSpacing(70, after: titleLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        foodDetailVC.view.addSubview(stackView)

        // StackView 제약 조건
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: foodDetailVC.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: foodDetailVC.view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: foodDetailVC.view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: foodDetailVC.view.trailingAnchor, constant: -20)
        ])

        // VC 를 UISheetPresentationController 로 선언
        foodDetailVC.modalPresentationStyle = .pageSheet
        if let sheetPresentationController = foodDetailVC.presentationController as? UISheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
        }

        // 팝업 뷰를 화면에 표시
        self.present(foodDetailVC, animated: true, completion: nil)

        // 선택한 셀의 선택 효과를 해제
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
