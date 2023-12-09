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
        let webViewController = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webViewController.urlString = url
        let navigationController = UINavigationController(rootViewController: webViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func connectButtonClicked(_ sender: UIButton) {
        if(titleLabel.text == "칼로리 계산"){
            openWebView(withURL: "https://tdeecalculator.net/")
        } else {
            
        }
    }
    
}
