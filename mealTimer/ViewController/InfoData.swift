//
//  File.swift
//  mealTimer
//
//  Created by 이재영 on 2023/12/07.
//

import Foundation

struct Sections {
    let name: String
    let imageName: String
}

extension Sections {
    static let list = [
    Sections(name: "칼로리 계산", imageName: "calculator"),
    Sections(name: "식단 구성", imageName: "diet")
    ]
}
