import SwiftUI


struct CounterNumber: View {
    var stepCounter: Int
    
    var body: some View {
        VStack {
            Text("\(stepCounter)")
                .font(.system(size: 60))
                .foregroundStyle(.white)
        }
    }
}
