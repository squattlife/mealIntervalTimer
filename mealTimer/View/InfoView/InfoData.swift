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
    let description: String
}

extension Sections {
    static let list = [
    Sections(name: "칼로리 계산", imageName: "calculator", description: "개개인마다 신체 스팩, 운동 습관, 건강 상태, 기초 및 활동대사량 등 신체 관련된 다양한 조건이 붙어 하루 소비 에너지량과 그에 따른 목표 체중을 위한 칼로리 섭취량이 다 다를 수 있습니다. 이를 위해서, TDEE(Total Daily Energy Expenditure) Calculator를 이용하여 더 정확하고 효율적이며 자신의 목적에 맞는 총 열량 계산과 식단 계획을 이룰 수 있습니다. 사용방법은 해당 요구항목에 본인의 나이, 성별, 신체 스펙, 활동량 등을 기입하면 됩니다. 간편하고 더 정확한 계산을 경험해보세요! "),
    Sections(name: "식단 구성", imageName: "diet", description: "본인의 상태와 설정한 목표 체중 혹은 방향성에 맞는 칼로리와 영양성분에 적합한 식단 구성을 이뤄보세요. 해당 식단 구성표에는 다이어트 및 건강 증진, 근성장 촉진 등 신체적 측면에서 매우 이로운 식품으로 구성되어 있습니다. 쉽고 간편하게 자신의 식단을 구성해보세요!")
    ]
}
