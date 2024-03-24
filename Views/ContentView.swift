import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var applicationModel: ApplicationModel
    
    var body: some View {
        HomeView().environmentObject(applicationModel)
    }
}



