//
//  CalendarViewController.swift
//  mealTimer
//
//  Created by 이재영 on 2023/11/25.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController {
    
    var cycleTrue: Bool = false
 
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var checkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateCycleTrue(value: Bool) {
        cycleTrue = value
    }
    
    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
        updateDateLabel(sender.date)
        
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DataControl")
        request.predicate = NSPredicate(format: "dateString == %@", dateString)
        
        do {
            let result = try context.fetch(request)
            if let data = result.first as? NSManagedObject {
                if data.value(forKey: "value") is Bool {
                    checkLabel!.text = "해당 요일의 식단을 완료했습니다"
                } else {
                    print("해당 날짜의 데이터가 없습니다.")
                }
            } else {
                print("해당 날짜의 데이터가 없습니다.")
            }
        } catch {
            print("Failed fetching")
        }
    }



    
    func updateDateLabel(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
    }
    
}

