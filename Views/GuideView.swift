import SwiftUI

struct GuideView: View {
    @EnvironmentObject var applicationModel: ApplicationModel
    
    var body: some View {
        let excerciseName = applicationModel.getExcerciseName()
        let stepName = applicationModel.getStepName()
        // let stepId = applicationModel.getStepId()
        VStack {
            if(applicationModel.showCompletionMessage) {
                MessageCardView().environmentObject(applicationModel)
            } 
            else if(applicationModel.showStepCounter){
                StepCounterView().environmentObject(applicationModel)
            }
            else {
                Text(excerciseName)
                Text(stepName)
                StepCardView().environmentObject(applicationModel)
            }
        }
    }
}
