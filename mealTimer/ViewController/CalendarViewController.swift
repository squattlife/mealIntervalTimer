//
//  CalendarViewController.swift
//  mealTimer
//
//  Created by 이재영 on 2023/11/25.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController {
 
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var checkLabel: UILabel!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var blurView2: UIVisualEffectView!
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "background.png")
        blurView.layer.cornerRadius = 30
        blurView2.layer.cornerRadius = 30
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
                    dateLabel.text = dateString
                    blurView2.backgroundColor = UIColor.systemGreen
                } else {
                    checkLabel.text = "식단 미완료!"
                    checkLabel.textColor = UIColor.systemRed
                    dateLabel.text = dateString
                    blurView2.backgroundColor = UIColor.systemRed
                }
            } else {
                checkLabel!.text = "식단 미완료!"
                checkLabel.textColor = UIColor.systemRed
                blurView2.backgroundColor = UIColor.systemRed
                dateLabel.text = dateString
            }
        } catch {
            print("Failed fetching")
        }
    }
    
}

