import SwiftUI
import HealthKit

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
//            Button("Authorize Health Data")
        }
        .onAppear {
            manager.fetchActivityForLastMonth()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
