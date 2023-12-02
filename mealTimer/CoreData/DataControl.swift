//
//  DataControl.swift
//  mealTimer
//
//  Created by 이재영 on 2023/12/03.
//

import Foundation
import CoreData

@objc(DataControl)
public class DataControl: NSManagedObject {
    @NSManaged public var dateString: String
    @NSManaged public var value: Bool
    // 추가적인 속성들...
}
