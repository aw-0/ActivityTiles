//
//  Structures.swift
//  MoveWidgetExtension
//
//  Created by Andrew on 6/4/24.
//

import Foundation

struct CalorieData: Hashable {
    let date: Date
    let calories: Double
}

func getLargeWidgetDemoData() -> Set<CalorieData> {
    var largeWidgetDemoData: Set<CalorieData> = Set()
    for index in 0 ..< 81 {
        largeWidgetDemoData.insert(CalorieData(date: Calendar.current.date(byAdding: .day, value: -index, to: Date())!, calories: Double(index)*10))
    }
    return largeWidgetDemoData
}
