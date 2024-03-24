import SwiftUI

import SwiftUI

let messageCountDownTimer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()

struct MessageCardView : View {
    @EnvironmentObject var applicationModel: ApplicationModel
   
    @State var messageCounter: Int = 0
    @State var messageCount: Int = 3
    
    var body: some View {
        //let stepName = applicationModel.getStepName()
       
        VStack(alignment: .center, spacing: 16, content: {
            HStack(alignment: .center, content: {
                Image(systemName: "checkmark.circle").resizable().frame(width: 35.0, height: 35.0).fontWeight(.bold).foregroundColor(.green).padding(.top, 20).padding(.bottom, 20).padding(.leading, 20)
                Text(applicationModel.completionMessage).font(.title)
                .padding(.all, 20)
            })
        }).frame(width: 400, height: 120)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .shadow(radius: 9)
        .onReceive(messageCountDownTimer) { time in
            if (self.messageCounter < self.messageCount) {
                self.messageCounter += 1
            }
            if(self.messageCompleted()) {
                //print("on message on receive")
                if(applicationModel.moveToNextExcercise == false){
                    applicationModel.moveStep()
                }
                applicationModel.moveToNextExcercise = false
                applicationModel.gatherPrediction = true
                applicationModel.showCompletionMessage = false
                applicationModel.completionMessage = ""
                if(applicationModel.sessionCompleted) {
                    applicationModel.resetSelection()
                } 
                
                 
            }
        }
    }
    
    func messageCompleted() -> Bool {
        return messageProgress() == 1
    }
    
    func messageProgress() -> CGFloat {
        return (CGFloat(messageCounter) / CGFloat(messageCount))
    }
}
