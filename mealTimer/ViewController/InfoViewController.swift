//
//  InfoViewController.swift
//  mealTimer
//
//  Created by 이재영 on 2023/12/05.
//

import UIKit

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let list = Sections.list
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // cell의 estimated size를 코드로 설정
        if let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowlayout.estimatedItemSize = .zero
        }
        
        // 왼쪽 오른쪽 여백 두기 - inset
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCell", for: indexPath) as? InfoCell else {
            return UICollectionViewCell()
        }
        
        let items = list[indexPath.item]
        cell.configure(items)
        
        return cell
    }
}

extension InfoViewController: UICollectionViewDelegateFlowLayout{
    // 사이즈 정하기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interItemSpacing: CGFloat = 10
        
        // inset 설정으로 인한 padding 설정
        let padding: CGFloat = 16
        
        let width = (collectionView.bounds.width - interItemSpacing * 3 - padding * 2) / 1.7
        let height = width * 1.3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = list[indexPath.item]
        print(">>> selected: \(section.name)")
    }
}

