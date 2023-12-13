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
    @IBOutlet var connectButton: UIButton!
    
    var detailCell: Sections = Sections(name: "", imageName: "", description: "")
    var identifier = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        imageView.image = UIImage(named: detailCell.imageName)
        titleLabel.text = detailCell.name
        descriptionLabel.text = detailCell.description
    }
    
    // WebView
    func openWebView(withURL url: String) {
        let vc = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.urlString = url
        let webvc = UINavigationController(rootViewController: vc)
        present(webvc, animated: true, completion: nil)
    }
    
    func openFoodView() {
        
    }
    
    @IBAction func connectButtonClicked(_ sender: UIButton) {
        if(titleLabel.text == "칼로리 계산"){
            openWebView(withURL: "https://tdeecalculator.net/")
        } else {
            let vc = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "FoodViewController") as! FoodViewController
            let foodvc = UINavigationController(rootViewController: vc)
            present(foodvc, animated: true, completion: nil)
        }
    }
    
}
