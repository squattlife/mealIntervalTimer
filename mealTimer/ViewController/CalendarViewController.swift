//
//  CalendarViewController.swift
//  mealTimer
//
//  Created by 이재영 on 2023/11/25.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController {
 
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var checkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func datePickerSelected(_ sender: UIDatePicker) {

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
                    checkLabel.text = "식단 완료!"
                    checkLabel.textColor = UIColor.systemGreen
                } else {
                    checkLabel.text = "식단 미완료 상태"
                    checkLabel.textColor = UIColor.systemRed
                }
            } else {
                checkLabel!.text = "식단 미완료 상태"
                checkLabel.textColor = UIColor.systemRed
            }
        } catch {
            print("Failed fetching")
        }
    }
    
}

