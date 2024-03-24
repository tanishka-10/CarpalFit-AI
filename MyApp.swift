import SwiftUI

@main
struct MyApp: App {
    @StateObject var applicationModel = ApplicationModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(applicationModel)
        }
    }
}
