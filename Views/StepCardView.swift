import SwiftUI

struct StepCardView : View {
    @EnvironmentObject var applicationModel: ApplicationModel
    var body: some View {
        let stepName = applicationModel.getStepName()
        let stepId = applicationModel.getStepId()
        VStack(alignment: .center, spacing: 16, content: {
            Image(stepId)
                .resizable()
                .frame(width: 200, height:200)
            VStack(alignment: .center, content: {
                Text(stepName).font(.headline)
            }).padding(.horizontal, 8).padding(.bottom, 16)
        })
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        .shadow(radius: 9)
    }
}
