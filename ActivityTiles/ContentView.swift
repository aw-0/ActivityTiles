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
            Text("Welcome to Activity Tiles! Please grant us access to the Health App in order to populate the data.")
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

func checkHealthAccess() -> Void {
    let sharedPerms: Set<HKObjectType> = [
        HKObjectType.activitySummaryType()
    ]
    Task {
       try HKHealthStore().getRequestStatusForAuthorization(toShare: [], read: sharedPerms) { (status, error) in
           if let error = error {
               print("Error: \(error.localizedDescription)")
               return
           }
           
           switch status {
           case .unknown:
               print("The authorization status is unknown.")
           case .shouldRequest:
               promptHealthAccess()
               print("The app should request authorization.")
           case .unnecessary:
               print("The app has already requested authorization.")
           @unknown default:
               print("A new status has been added that is not handled.")
           }
       }
   }
}

func promptHealthAccess() -> Void {
    let sharedPerms: Set<HKObjectType> = [
        HKObjectType.activitySummaryType()
    ]
            
    // Request HealthKit authorization with a completion handler
    Task {
        do {
            try await HKHealthStore().requestAuthorization(toShare: [], read: sharedPerms)
        } catch {
            print("error getting health data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
