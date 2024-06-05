//
//  HealthManager.swift
//  ExerciseWidget
//
//  Created by Andrew on 10/14/23.
//

import SwiftUI
import HealthKit
import Combine

class HealthManager: ObservableObject {
    @Published var avgCal: Double = 0.0

    private var healthStore = HKHealthStore()

    func fetchCalorieLargeWidgetActivity(resultsHandler: @escaping (HKActivitySummaryQuery, [HKActivitySummary]?, (any Error)?) -> Void) {
        // constants
        let currentDates = 84

        let calendar = Calendar.autoupdatingCurrent
        guard let startDate = calendar.date(byAdding: .day, value: -currentDates, to: Date()) else {
            print("Failed to calculate start date.")
            DispatchQueue.main.async {
                self.avgCal = 0.0
            }
            return
        }
        let startComponents = calendar.dateComponents([.year, .month, .day, .calendar], from: startDate)
        let endComponents = calendar.dateComponents([.year, .month, .day, .calendar], from: Date())
        let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: startComponents, end: endComponents)
        let query = HKActivitySummaryQuery(predicate: predicate, resultsHandler: resultsHandler)
        healthStore.execute(query)
    }
}
