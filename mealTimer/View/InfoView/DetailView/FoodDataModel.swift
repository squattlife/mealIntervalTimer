//
//  FoodData.swift
//  mealTimer
//
//  Created by 이재영 on 2023/12/10.
//

import Foundation

struct FoodItem: Codable {
    let 식품이름: String
    let 기준함량: String
    let 열량: Double
    let 탄수화물: Double
    let 단백질: Double
    let 지방: Double
}
