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
        MoveEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (MoveEntry) -> ()) {
        let entry = MoveEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MoveEntry] = []
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 2 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = MoveEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MoveEntry: TimelineEntry {
    let date: Date
}

struct MoveWidgetEntryView : View {
    var entry: Provider.Entry
    var manager = HealthManager()
    @State var avgCal = 100.0

    var body: some View {
        VStack {
            Text("Avg Cal: \(avgCal)")
        }
        .onAppear {
            manager.fetchLargeWidgetActivity { avgCal in
                self.avgCal = avgCal
            }
        }
    }
}

struct MoveWidget: Widget {
    let kind: String = "MoveWidget"

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
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    MoveWidget()
} timeline: {
    MoveEntry(date: .now)
}
