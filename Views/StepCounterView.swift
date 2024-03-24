import SwiftUI

let stepCountDownTimer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()

struct StepCounterView: View {
    @EnvironmentObject var applicationModel: ApplicationModel
    @State var stepCounter: Int = 0
    @State var stepSwitchCounter: Int = 0
    @State var intervalCounter: Int = 0
    var stepsCount: Int = 5
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .fill(Color.clear)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle().stroke(Color.gray.opacity(0.6), lineWidth: 25)
                    )
                
                Circle()
                    .fill(Color.clear)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle().trim(from:0, to: stepProgress())
                            .stroke(
                                style: StrokeStyle(
                                    lineWidth: 25,
                                    lineCap: .round,
                                    lineJoin:.round
                                )
                            )
                            .foregroundColor(
                                (stepCompleted() ? Color.green.opacity(1): Color.orange.opacity(1))
                            ).animation(
                                Animation.easeInOut(duration: 4), value: UUID()
                            )
                    )
                
                CounterNumber(stepCounter: stepCounter)
            }
        }.onReceive(stepCountDownTimer) { time in
            if (self.stepCounter < self.stepsCount && self.intervalCounter % 3 == 0) {
                self.stepCounter += 1
            } 
            self.intervalCounter += 1
            self.stepSwitchCounter += 1
            if(self.stepSwitchCounter - self.stepCounter == 11) {
                self.stepSwitchCounter = 0
                applicationModel.moveExcercise()
            }
        }.frame(width: 450, height:320)
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
            .shadow(radius: 9)
    }
    
    func stepCompleted() -> Bool {
        return stepProgress() == 1
    }
    
    func stepProgress() -> CGFloat {
        return (CGFloat(stepCounter) / CGFloat(stepsCount))
    }
}
