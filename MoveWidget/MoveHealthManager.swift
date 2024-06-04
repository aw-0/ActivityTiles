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
                try healthStore.getRequestStatusForAuthorization(toShare: [], read: sharedPerms) { (status, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    switch status {
                    case .unknown:
                        print("The authorization status is unknown.")
                    case .shouldRequest:
                        print("The app should request authorization.")
                    case .unnecessary:
                        print("The app has already requested authorization.")
                    @unknown default:
                        print("A new status has been added that is not handled.")
                    }
                }
            } catch {
                print("error getting health data")
            }
        }
        
    }
    
    func fetchLargeWidgetActivity(completion: @escaping (Double) -> Void) {
        // constants
        let currentDates = 84

        // totals for average
        var totalCal = 0.0
        var avgCal = 0.0

        let calendar = Calendar.autoupdatingCurrent
        guard let startDate = calendar.date(byAdding: .day, value: -currentDates, to: Date()) else {
            print("Failed to calculate start date.")
            completion(0.0)
            return
        }
        let startComponents = calendar.dateComponents([.year, .month, .day, .calendar], from: startDate)
        let endComponents = calendar.dateComponents([.year, .month, .day, .calendar], from: Date())
        let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: startComponents, end: endComponents)

        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) -> Void in
            if let error = error {
                // Handle the error here
                print("Error fetching activity summaries: \(error)")
                return completion(0.0)
            }

            guard let summaries = summaries else {
                print("No summaries found.")
                completion(0.0)
                return
            }

            for sample in summaries {
                totalCal += sample.activeEnergyBurned.doubleValue(for: .kilocalorie())
            }

            avgCal = totalCal / Double(currentDates)
            print(avgCal)
            completion(avgCal)
        }
        healthStore.execute(query)
    }
}
