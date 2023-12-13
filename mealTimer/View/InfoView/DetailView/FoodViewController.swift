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
        cell.detailTextLabel?.text = "열량: \(foodItems[indexPath.row].열량) kCal, 단백질: \(foodItems[indexPath.row].단백질)g, 지방: \(foodItems[indexPath.row].지방)g"

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 원하는 높이로 조절
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 셀의 detailTextLabel의 텍스트를 가져옵니다.
        let selectedFoodDetail = foodItems[indexPath.row]

        // 새로운 UIViewController를 생성합니다.
        let foodDetailVC = UIViewController()
        foodDetailVC.view.backgroundColor = UIColor(named: "sheetColor")

        // 뷰 컨트롤러에 레이블을 추가합니다.
        let label = UILabel()
        label.text = "\(selectedFoodDetail)"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        foodDetailVC.view.addSubview(label)

        // 레이블의 제약 조건을 설정합니다.
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: foodDetailVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: foodDetailVC.view.centerYAnchor)
        ])

        // 뷰 컨트롤러를 UISheetPresentationController로 설정합니다.
        foodDetailVC.modalPresentationStyle = .pageSheet
        if let sheetPresentationController = foodDetailVC.presentationController as? UISheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
        }

        // 팝업 뷰를 화면에 표시합니다.
        self.present(foodDetailVC, animated: true, completion: nil)

        // 선택한 셀의 선택 효과를 해제합니다.
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
