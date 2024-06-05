//
//  Structures.swift
//  MoveWidgetExtension
//
//  Created by Andrew on 6/4/24.
//

import Foundation
import SwiftUI

struct CalorieData: Hashable {
    let date: Date
    let calories: Double
}

let tileColor = Color(UIColor(red: 235/255.0, green: 64/255.0, blue: 52/255.0, alpha: 1))//Color(UIColor(red: 182/255.0, green: 245/255.0, blue: 89/255.0, alpha: 1))

func getLargeWidgetDemoData() -> Array<CalorieData> {
    var largeWidgetDemoData: Array<CalorieData> = Array()
    for index in 0 ..< 98 {
        largeWidgetDemoData.append(CalorieData(date: Calendar.current.date(byAdding: .day, value: -index, to: Date())!, calories: Double(index)*10))
    }
    return largeWidgetDemoData
}

func determineOpacity(part: Double, whole: Double) -> Double {
    print("\(part) vs \(whole)")
    let percent = part/whole
    if (percent <= 0.2) {
        return 0.1
    } else if (percent <= 0.5) {
        return 0.25
    } else if (percent > 0.5 && percent < 0.75) {
        return 0.5
    } else if (percent > 0.75 && percent < 1) {
        return 0.75
    } else {
        return 1
    }
}
