import SwiftUI

struct StepModel: Hashable, Equatable {
    private var stepId: String
    private var stepName: String
    
    init(stepId: String, stepName: String) {
        self.stepId = stepId
        self.stepName = stepName
    }
    
    func getStepId() -> String{
        return self.stepId;
    }
    
    func getStepName() -> String{
        return self.stepName;
    }
}
