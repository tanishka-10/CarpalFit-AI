import SwiftUI

struct StepView: View {
    @EnvironmentObject var applicationModel: ApplicationModel
    
    var body: some View {
        GeometryReader{ geo in
            VStack {
                VStack() {
                    GuideView().environmentObject(applicationModel)
                }.frame(height: geo.size.height * (1/3))
                VStack() {
                    CameraView().environmentObject(applicationModel)
                }.frame(height: geo.size.height * (2/3))
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
            ).background(
                LinearGradient(colors: [.indigo.opacity(0.7), .blue.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea())
            .onAppear { applicationModel.shouldPauseCamera = false }
            .onDisappear{applicationModel.resetSelection() }
        }.environmentObject(applicationModel)
    }
}
