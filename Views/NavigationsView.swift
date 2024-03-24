import SwiftUI

import SwiftUI

struct NavigationsView: View {
    @EnvironmentObject var applicationModel: ApplicationModel
    
    var body: some View {
        VStack {
            Text("NavigationView")
            NavigationLink(destination: SelectionView()) {
                Text("Go To Selection")
            }
        }
        .environmentObject(applicationModel)
        .onAppear {
            applicationModel.resetSelection()
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        ).background(
            LinearGradient(colors: [.indigo.opacity(0.7), .blue.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea())
    }
}
