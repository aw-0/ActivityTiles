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
    
    func fetchActivityForLastMonth() {
        let calendar = Calendar.autoupdatingCurrent
        let startDate = calendar.date(byAdding: .month, value: -1, to: Date())
        let startComponents = calendar.dateComponents([.year, .month, .day, .calendar], from: startDate!)
        let endComponents = calendar.dateComponents([.year, .month, .day, .calendar], from: Date())
        let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: startComponents, end: endComponents);
        let query = HKActivitySummaryQuery(predicate: predicate) {
            (query, summaries, error) -> Void in
            
            if error != nil {
                // Handle the error here
                print(error)
                return
            }
            for sample in summaries! {
                print("\(sample.dateComponents(for: calendar).month!)-\(sample.dateComponents(for: calendar).day!)")
                print("Move: \(sample.activeEnergyBurned.doubleValue(for: .kilocalorie())), Exercise: \(sample.appleExerciseTime.doubleValue(for: .minute())), Stand: \(sample.appleStandHours.doubleValue(for: .count()))")
            }
        }
        
        healthStore.execute(query)
    }
}
