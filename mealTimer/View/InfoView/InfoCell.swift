//
//  InfoCollectionViewCell.swift
//  mealTimer
//
//  Created by 이재영 on 2023/12/07.
//

import UIKit

class InfoCell: UICollectionViewCell {
    
    @IBOutlet var sectionImage: UIImageView!
    @IBOutlet var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sectionLabel.numberOfLines = 1
        // cell 에 따라서 폰트를 조정시키는 것
        sectionLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configure(_ sections: Sections){
        sectionImage.image = UIImage(named: sections.imageName)
        sectionLabel.text = sections.name
    }
}
