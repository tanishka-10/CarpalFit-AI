import SwiftUI
import CoreML
import CreateML

final class TrainerDataModel: ObservableObject {
    enum State: String {
        case inactive
        case active
        case finished
        case error
    }
    
    var resourceDirectory: URL? = Bundle.main.resourceURL
    
    var trainingMetrics = TrainingMetrics()
    
    var modelName: String = "HandExcerciseModel"
    @Published var currentTrainer: HandPoseTrainer?
//    @Published var currentTrainingDataset: Dataset?
//    @Published var currentValidationDataset: Dataset?
    @Published var completed: Double = 0.0
    @Published var currentPhase: String = ""
    @Published var currentState: State = .inactive
    
//    var localTrainingDatasets: [Dataset] {
//        let trainingDirectory = resourceDirectory!.appendingPathComponent("Dataset", isDirectory: true).appendingPathComponent("Training", isDirectory: true)
//        var datasets: [Dataset] = []
//        for localURL in trainingDirectory.directoryContents {
//            let folderName = localURL.lastPathComponent
//            let dataset = Dataset(name: folderName,
//                                  type: .training,
//                                  steps: steps,
//                                  resourceDirectory: localURL)
//            datasets.append(dataset)
//        }
//        return datasets
//    }
//    
//    var localValidationDatasets: [Dataset] {
//        let validationDirectory = resourceDirectory!.appendingPathComponent("Dataset", isDirectory: true).appendingPathComponent("Validation", isDirectory: true)
//        var datasets: [Dataset] = []
//        for localURL in validationDirectory.directoryContents {
//            let folderName = localURL.lastPathComponent
//            let dataset = Dataset(name: folderName,
//                                  type: .validation,
//                                  steps: steps,
//                                  resourceDirectory: localURL)
//            datasets.append(dataset)
//        }
//        return datasets
//    }
//    
//    var localValidationDatasetNames: [String] {
//        localValidationDatasets.map { $0.name }
//    }
    
//    var steps: [String] {
//        ApplicationModel.validStepNames.map { $0.capitalized }
//    }
    
    func reset() {
        trainingMetrics = TrainingMetrics()
        currentTrainer?.cancel()
        currentTrainer = nil
//        currentTrainingDataset = nil
//        currentValidationDataset = nil
        completed = 0.0
        currentPhase = ""
        currentState = .inactive
    }
}

extension TrainerDataModel: @unchecked Sendable {}
