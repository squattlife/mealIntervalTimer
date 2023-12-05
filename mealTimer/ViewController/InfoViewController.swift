//
//  InfoViewController.swift
//  mealTimer
//
//  Created by 이재영 on 2023/12/05.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "background.png")
    }
}
