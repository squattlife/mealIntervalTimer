//
//  DetailViewController.swift
//  mealTimer
//
//  Created by 이재영 on 2023/12/10.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var detailCell: Sections = Sections(name: "", imageName: "", description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        imageView.image = UIImage(named: detailCell.imageName)
        titleLabel.text = detailCell.name
        descriptionLabel.text = detailCell.description
    }
}
