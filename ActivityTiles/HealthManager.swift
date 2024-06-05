//
//  HealthManager.swift
//  ExerciseWidget
//
//  Created by Andrew on 10/14/23.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var output = ""
    
    init() {
        let sharedPerms: Set<HKObjectType> = [
            HKObjectType.activitySummaryType()
        ]
        
        // Request HealthKit authorization with a completion handler
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: sharedPerms)
            } catch {
                print("error getting health data")
            }
        }
        
    }
    
    func fetchLargeWidgetActivity() {
        // constants
        let currentDates = 98

        // totals for average
        var totalCal = 0.0
        var totalExer = 0.0
        var totalStand = 0.0

        let calendar = Calendar.autoupdatingCurrent
        guard let startDate = calendar.date(byAdding: .day, value: -currentDates, to: Date()) else {
            print("Failed to calculate start date.")
            return
        }
        let startComponents = calendar.dateComponents([.year, .month, .day, .calendar], from: startDate)
        let endComponents = calendar.dateComponents([.year, .month, .day, .calendar], from: Date())
        let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: startComponents, end: endComponents)

        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) -> Void in
            if let error = error {
                // Handle the error here
                print("Error fetching activity summaries: \(error)")
                return
            }

            guard let summaries = summaries else {
                print("No summaries found.")
                return
            }

            for sample in summaries {
                totalCal += sample.activeEnergyBurned.doubleValue(for: .kilocalorie())
                totalExer += sample.appleExerciseTime.doubleValue(for: .minute())
                totalStand += sample.appleStandHours.doubleValue(for: .count())
            }

            let avgCal = totalCal / Double(currentDates)
            let avgExer = totalExer / Double(currentDates)
            let avgStand = totalStand / Double(currentDates)
            DispatchQueue.main.async {
                self.output +=  "Avg Cal: \(avgCal)\n"
                self.output += "Avg Exer: \(avgExer)\n"
                self.output += "Avg Stand: \(avgStand)"
            }
        }
        
        healthStore.execute(query)
    }
}
