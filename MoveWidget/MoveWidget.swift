//
//  MoveWidget.swift
//  MoveWidget
//
//  Created by Andrew on 6/4/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MoveEntry {
        MoveEntry(date: Date(), avgCals: 410.0, allCalorieData: getLargeWidgetDemoData())
    }

    func getSnapshot(in context: Context, completion: @escaping (MoveEntry) -> ()) {
        let entry = MoveEntry(date: Date(), avgCals: 420.0, allCalorieData: getLargeWidgetDemoData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let manager = HealthManager()
        var totalCal = 0.0
        var allCalorieData = Array<CalorieData>()
        // refresh every 15 minutes
        let currentDate = Date()
        let refreshMinuteGranuity = 15
        let refreshDate = Calendar.current.date(
            byAdding: .minute,
            value: refreshMinuteGranuity,
            to: currentDate
        )!
        
        manager.fetchCalorieLargeWidgetActivity { (query, summaries, error) -> Void in
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
                allCalorieData.append(CalorieData(date: sample.dateComponents(for: Calendar.current).date!, calories: sample.activeEnergyBurned.doubleValue(for: .kilocalorie())))
            }

            let average = summaries.isEmpty ? 0 : totalCal / Double(summaries.count)
            print("Total Calories: \(totalCal), Average: \(average)")
            
            let entry = MoveEntry(date: currentDate, avgCals: average, allCalorieData: allCalorieData)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            print("Next refresh: \(refreshDate)")
            completion(timeline)
        }
    }
}

struct MoveEntry: TimelineEntry {
    let date: Date
    let avgCals: Double
    let allCalorieData: Array<CalorieData>
}

struct MoveWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ForEach(0..<7) { col in
                HStack {
                    ForEach(0..<14) { row in
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(boxColor)
                            .opacity(determineOpacity(part: entry.allCalorieData[col*7 + row].calories, whole: entry.avgCals))
                            .frame(height: 12)
                            .padding(EdgeInsets(top: 0, leading: -1, bottom: 0, trailing: -1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(boxColor, lineWidth: 1.5)
                                    .padding(EdgeInsets(top: 0, leading: -1, bottom: 0, trailing: -1))
                            )
                    }
                }
            }
        }
    }
}

struct MoveWidget: Widget {
    let kind: String = "MoveWidget"
    @Environment(\.colorScheme) var colorScheme

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MoveWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MoveWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Move Tracker Widget")
        .description("Track your move progress over time!")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    MoveWidget()
} timeline: {
    MoveEntry(date: .now, avgCals: 415.0, allCalorieData: getLargeWidgetDemoData())
}
