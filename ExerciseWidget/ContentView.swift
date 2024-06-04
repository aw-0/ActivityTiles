import SwiftUI
import HealthKit
import WidgetKit

struct ContentView: View {
    @StateObject var manager = HealthManager()
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to ExcerciseWidget! Please grant us access to the Health App in order to populate the data.")
                .multilineTextAlignment(.center)
                .padding()
            Text(manager.output)
            Button("TestReload", action: {
                WidgetCenter.shared.reloadTimelines(ofKind: "MoveWidget")
            })
            Button("Get Activity", action: manager.fetchLargeWidgetActivity)
        }
        .onAppear {
            manager.fetchLargeWidgetActivity()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
