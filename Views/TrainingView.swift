import SwiftUI
import Charts

struct TrainingView: View {
   
    //@EnvironmentObject var applicationModel: ApplicationModel
    @ObservedObject var trainerDataModel: TrainerDataModel
    
    private var completed: Int {
        Int(trainerDataModel.completed)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            if trainerDataModel.currentState == .active {
                trainingSessionInfo()
            } else {
                HStack{
                    Button {
                        train()
                    } label: {
                        Text("Train")
                    }
                    .foregroundColor(.accentColor)
                    Button {
                        trainerDataModel.reset()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        .padding(.horizontal)
        .toolbar {
            trainButton()
            cancelButton()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Train Hand Pose Model")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: trainerDataModel.currentState) { _ in
            switch trainerDataModel.currentState {
            case .finished, .error:
                closeView()
            default: break
            }
        }
    }

    private func trainingSessionInfo() -> some View {
        VStack(alignment: .leading) {
            HStack {
                ProgressView("Training Progress - Do not leave the screen", value: trainerDataModel.completed, total: 100)
                    .font(.subheadline)
                    .tint(.black)
            }
            if !trainerDataModel.currentPhase.isEmpty {
                Text("Current training phase: \(trainerDataModel.currentPhase)")
                    .font(.subheadline)
            }
        }
        .padding(.bottom)
    }
    
    private func trainButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if trainerDataModel.currentState != .active {
                Button {
                    train()
                } label: {
                    Text("Train")
                }
                .foregroundColor(.accentColor)
            }
        }
    }
    
    private func closeView() {
        trainerDataModel.reset()
    }
    
    private func cancelButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                trainerDataModel.reset()
            } label: {
                Text("Cancel")
            }
            .foregroundColor(.accentColor)
        }
    }
    
   private func train() {
        //guard trainerDataModel.currentTrainingDataset != nil else { return }
        let trainer = HandPoseTrainer()
        trainerDataModel.currentTrainer = trainer
        Task(priority: .userInitiated) {
            do {
                try await trainer.train(with: trainerDataModel)
            } catch {
                print("Could not train ML model: \(error.localizedDescription)")
            }
        }
    }
}


struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView(trainerDataModel: TrainerDataModel())
    }
}
