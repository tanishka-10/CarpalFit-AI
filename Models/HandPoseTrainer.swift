import SwiftUI

import CreateML
import Foundation
import CoreML
import Combine

final class HandPoseTrainer {
    private var imageAugmentationParameters = MLHandPoseClassifier.ImageAugmentationOptions()
   
    
    var classifier: MLHandPoseClassifier?
    
    var session: TrainingSession?
    
    func train(with dataModel: TrainerDataModel) async throws {
        let trainingDataset = dataModel.resourceDirectory!.appendingPathComponent("Dataset", isDirectory: true).appendingPathComponent("Training", isDirectory: true)
        print(trainingDataset.absoluteString)
        var modelParameters = MLHandPoseClassifier.ModelParameters()
        
        let validationDataset = dataModel.resourceDirectory!.appendingPathComponent("Dataset", isDirectory: true).appendingPathComponent("Validation", isDirectory: true)
        modelParameters.validation = .dataSource(.labeledDirectories(at: validationDataset)) 
        
        imageAugmentationParameters.insert(.rotate)
        imageAugmentationParameters.insert(.translate)
        imageAugmentationParameters.insert(.horizontallyFlip)
        imageAugmentationParameters.insert(.scale)
        
        modelParameters.augmentationOptions = imageAugmentationParameters
        modelParameters.maximumIterations = 100
        let trainingDataSource = MLHandPoseClassifier.DataSource.labeledDirectories(at: trainingDataset)
        try await runTrainingSession(with: trainingDataSource, dataModel: dataModel, modelParameters: modelParameters)
    }
    
    typealias TrainingSession = MLJob<MLHandPoseClassifier>
    
    private static func constructModelPath(with name: String) -> URL? {
        guard let modelDirectory = URL.modelDirectory else { return nil }
        let modelPath = modelDirectory.appendingPathComponent(name).appendingPathExtension("mlmodel")
        
        return modelPath
    }
    
    func saveMLModelToDisk(as name: String, with classifier: MLHandPoseClassifier) throws {
        guard let modelPath = HandPoseTrainer.constructModelPath(with: name) else {
            return
        }
        try classifier.write(to: modelPath)
        print("\(name).mlmodel was successfully saved to \(modelPath.relativePath)")
    }
    
    func runTrainingSession(with dataSource: MLHandPoseClassifier.DataSource, dataModel: TrainerDataModel, modelParameters: MLHandPoseClassifier.ModelParameters) async throws {
        let mlJob = try MLHandPoseClassifier.train(trainingData: dataSource,
                                                   parameters: modelParameters)
        session = mlJob
        Task { @MainActor in
            dataModel.currentState = .active
        }
        
        var subscriptions = Set<AnyCancellable>()
        
        mlJob.progress
            .publisher(for: \.fractionCompleted)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: RunLoop.main)
            .sink { completed in
                guard let progress = MLProgress(progress: mlJob.progress) else { return }
                
                if progress.phase.rawValue != dataModel.currentPhase {
                    dataModel.currentPhase = progress.phase.rawValue
                }
                
                dataModel.completed = round(completed*100)
                let metrics = MLProgress.Metric.allCases
                print("Progress \(dataModel.completed)%")
                for metric in metrics {
                    guard let value = progress.metrics[metric] else { continue }
                    guard let valueD = value as? Double else { return }
                    dataModel.trainingMetrics.addDatapointForType(type: metric.rawValue, x: completed, y: valueD)
                    print("Metric [\(metric.rawValue)]: \(value)")
                }            }
            .store(in: &subscriptions)
        
        
        mlJob.result
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: RunLoop.main)
            .sink { _ in
                
            } receiveValue: { classifier in
                dataModel.completed = 100.0
                self.classifier = classifier
                let name = dataModel.modelName ?? "customMLModel"
                do {
                    try self.saveMLModelToDisk(as: name, with: classifier)
                    dataModel.currentState = .finished
                } catch {
                    print("Error saving model: \(error.localizedDescription)")
                    dataModel.currentState = .error
                }
            }
            .store(in: &subscriptions)
    }
    
    func cancel() {
        session?.cancel()
    }
}
