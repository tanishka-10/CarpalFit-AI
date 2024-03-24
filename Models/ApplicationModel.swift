import SwiftUI
import Vision
import CoreML

final class ApplicationModel : ObservableObject {
    
    static var excerciseList = ["squeez" : ExcerciseModel(excerciseId: "squeez", name: "squeez desc"), 
                                "squeez 1": ExcerciseModel(excerciseId: "squeez 1", name: "squeez 1 desc"), 
                                "squeez 2": ExcerciseModel(excerciseId: "squeez 2", name: "squeez 2 desc"),
                                "squeez 3": ExcerciseModel(excerciseId: "squeez 3", name: "squeez 3 desc"),
                                "squeez 4": ExcerciseModel(excerciseId: "squeez 4", name: "squeez 4 desc"),
                                "squeez 5": ExcerciseModel(excerciseId: "squeez 5", name: "squeez 5 desc"),
                                "squeez 6": ExcerciseModel(excerciseId: "squeez 6", name: "squeez 6 desc"),
                                "squeez 7": ExcerciseModel(excerciseId: "squeez 7", name: "squeez 7 desc")]
    
    
    static var stepList = ["Rock": StepModel(stepId: "Rock", stepName: "Rock desc"), 
                           "Paper": StepModel(stepId: "Paper", stepName: "Paper desc")] 
    
    static var excerciseToStepsMap = ["squeez": ["Rock","Paper","Rock","Paper"], 
                                      "squeez 1": ["Rock","Paper"], 
                                      "squeez 2": ["Rock","Paper"], 
                                      "squeez 3": ["Paper","Rock","Paper"],
                                      "squeez 4": ["Paper"],
                                      "squeez 5": ["Paper","Rock"],
                                      "squeez 6": ["Paper","Rock","Paper","Paper","Rock","Paper"],
                                      "squeez 7": ["Paper","Rock","Paper","Paper","Rock"]]
    
    //static let defaultMLModelName = "handExcercise.mlmodel"
    static let defaultMLModelName = "HandExcerciseModel4.mlmodel"
    
//    static var validStepNames: [String] = {
//        return ApplicationModel.stepList.values.map { $0.getStepName() }
//    }()
    
    let predictionTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    let camera = Camera()
    
    @Published var currentMLModel: HandPoseMLModel? {
        didSet {
            guard let model = currentMLModel else { return }
            camera.mlDelegate?.updateMLModel(with: model)
        }
    }
    
    @Published var cards = [CardModel]()
    
    @Published var selectedExcercise = [String]()
    @Published var viewfinderImage: Image?
    
    @Published var ExcerciseIndex = 0 
    @Published var StepIndex = 0
    @Published var showNextStepMessage = false
    @Published var showNextExcerciseMessage = false
    @Published var gatherPrediction = true
    @Published var canPredict = false
    @Published var isHandInFrame: Bool = false
    //@Published var predictionProbability = PredictionMetrics()
    @Published var predictionLabel: String = ""
    @Published var isGatheringObservations: Bool = true
    @Published var defaultMLModel: HandPoseMLModel?
    @Published var showCompletionMessage: Bool = false
    @Published var completionMessage: String = ""
    @Published var showStepCounter: Bool = false
    @Published var sessionCompleted: Bool = false
    @Published var moveToNextExcercise: Bool = false
    
    @Published var shouldPauseCamera: Bool = false {
        didSet {
            if shouldPauseCamera {
                camera.stop()
                isGatheringObservations = false
            } else {
                Task {
                    await camera.start()
                }
            }
        }
    }
    
    init() {  
        camera.mlDelegate = self
        setDefaultMLModel()
        Task {
            await handleCameraPreviews()
        }
        for element in ApplicationModel.excerciseList.values {
            self.cards.append(CardModel(imageId: element.getExcerciseId(), imageName: ApplicationModel.excerciseList[element.getExcerciseId()]!.getName()))
        }
    }
    
    private func handleCameraPreviews() async {
        let imageStream = camera.previewStream.map { $0.image }
        for await image in imageStream {
            Task { @MainActor in
                self.viewfinderImage = image
            }
        }
    }
    
    func selectExcercise(excerciseId: String) {
        if !selectedExcercise.contains(excerciseId) {
            selectedExcercise.append(excerciseId)
        } else {
            guard let index = selectedExcercise.firstIndex(of: excerciseId) else {return}
            selectedExcercise.remove(at: index)
        }
        print(selectedExcercise)
    }
    
    func selectAllExcercise() {
        self.selectedExcercise = Array(ApplicationModel.excerciseList.keys)
    }
    
    func deSelectAllExcercise() {
        self.selectedExcercise = []
    }
    
    func resetSelection() {
        self.ExcerciseIndex = 0 
        self.StepIndex = 0
        self.showNextStepMessage = false
        self.showNextExcerciseMessage = false
        self.selectedExcercise = []
        self.gatherPrediction = true
        self.cards = []
        for element in ApplicationModel.excerciseList.values {
            self.cards.append(CardModel(imageId: element.getExcerciseId(), imageName: ApplicationModel.excerciseList[element.getExcerciseId()]!.getName()))
        }
        self.completionMessage = ""
        self.showCompletionMessage = false
        self.showStepCounter = false
        self.predictionLabel = ""
        self.shouldPauseCamera = true
        self.sessionCompleted = false
        self.moveToNextExcercise = false
    }
    
    func getExcerciseName() -> String {
        if (ApplicationModel.excerciseList.count > 0 && self.selectedExcercise.count > 0) {
            guard let excercise = ApplicationModel.excerciseList[self.selectedExcercise[self.ExcerciseIndex]] else {
                return ""
            }
            return excercise.getName()
        }
        return ""
    }
    func getExcerciseId() -> String {
        guard let excercise = ApplicationModel.excerciseList[self.selectedExcercise[self.ExcerciseIndex]] else {
            return ""
        }
        return excercise.getExcerciseId()
    }
    
    
    func getStep() -> StepModel? {
        if (ApplicationModel.excerciseToStepsMap.count > 0 && self.selectedExcercise.count > 0) {
            let excerciseSteps = ApplicationModel.excerciseToStepsMap[self.selectedExcercise[self.ExcerciseIndex]]
            let excerciseStep : String! 
            
            excerciseStep = excerciseSteps?[self.StepIndex]
            guard let step = ApplicationModel.stepList[excerciseStep] else {
                return nil
            }
            return step
        }
         return nil
    }
    
    func getStepName () -> String {
        guard let stepName = self.getStep()?.getStepName() else {
            return ""
        }
        return stepName
    }
    
    func getStepId () -> String {
        guard let stepId = self.getStep()?.getStepId() else {
            return ""
        }
        return stepId
    }
    
//    private func gatherHandPosePoints(from observation: VNHumanHandPoseObservation) throws -> [CGPoint] {
//        let allPointsDict = try observation.recognizedPoints(.all)
//        var allPoints: [VNRecognizedPoint] = Array(allPointsDict.values)
//        allPoints = allPoints.filter { $0.confidence > 0.5 }
//        let points: [CGPoint] = allPoints.map { $0.location }
//        return points
//    }
    
//    @MainActor
//    private func updateNodes(points: [CGPoint]) {
//        self.nodePoints = points
//    }
    
    @MainActor
    private func updatePredictions(output: HandPoseOutput) {
        predictionLabel = output.label.capitalized
        //predictionProbability.getNewPredictions(from: output.labelProbabilities)
    }
    
    @MainActor
    private func resetPrediction() {
        //nodePoints = []
        predictionLabel = ""
        //predictionProbability = PredictionMetrics()
        isHandInFrame = false
    }
    
    private func setDefaultMLModel()   {
        Task {
            guard let mlModel = await HandPoseMLModel.getDefaultMLModel() else { return }
            Task { @MainActor in
                self.defaultMLModel = mlModel
                self.currentMLModel = mlModel
                //self.availableHandPoseMLModels.insert(mlModel)
            }
        }
    }
    
    @MainActor
    private func checkIfReadyForNextStep()   {
        let excerciseId = self.getExcerciseId()
        let steps :[String]!
        steps = ApplicationModel.excerciseToStepsMap[excerciseId]
        let stepsCount :Int = steps.count
        self.gatherPrediction = false
        print("Expectecd: " + self.getStepId())
        print("Predicted: " + self.predictionLabel)
        if(self.getStepId() == self.predictionLabel){
            Task { @MainActor in
                self.gatherPrediction = false
            }
            if (self.StepIndex + 1 < stepsCount) {
                self.completionMessage = "Amazing! Lets move onto next step"
                self.showCompletionMessage = true
            } else {
               self.showStepCounter = true 
            }
        } 
        else {
            Task { @MainActor in
                self.gatherPrediction = true
            }
        }
    }
    
    func moveStep() {
        let excerciseId = self.getExcerciseId()
        let steps :[String]!
        steps = ApplicationModel.excerciseToStepsMap[excerciseId]
        self.showStepCounter = false
        let stepsCount :Int = steps.count
        if (self.StepIndex + 1 < stepsCount) {
            //self.completionMessage = "Amazing! Lets move onto next step"
            //self.showCompletionMessage = true
            self.moveToNextExcercise = false
            print("moveStep")
            print(StepIndex)
            print(excerciseId)
            self.StepIndex = self.StepIndex + 1
            //print("more steps remaining")
        }
    }
    
    func moveExcercise() {
        let exceciseCount :Int = self.selectedExcercise.count
        self.showStepCounter = false
        if (self.ExcerciseIndex + 1 < exceciseCount) {
            // print("Move to next excercise")
            self.moveToNextExcercise = true
            self.showCompletionMessage = true
            self.completionMessage = "Amazing! Lets move onto next excercise"
            self.StepIndex = 0
            self.ExcerciseIndex = self.ExcerciseIndex + 1
        }
        else {
            //print("Excercise session completed")
            self.showCompletionMessage = true
            self.sessionCompleted = true
            self.completionMessage = "Amazing! We finished the session!!"
            //print(self.ExcerciseIndex)
            //print(self.StepIndex)
        }
    }
}

extension ApplicationModel: MLDelegate {
    func gatherObservations(pixelBuffer: CVImageBuffer) async {
        guard canPredict && gatherPrediction else { return }
        
        Task { @MainActor in
            canPredict = false
        }
   
        guard let mlModel = camera.currentMLModel else {
            await resetPrediction()
            return
        }
         
        Task {
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
            do {
                try imageRequestHandler.perform([camera.handPoseRequest])
                guard let observation = camera.handPoseRequest.results?.first else {
                    await resetPrediction()
                    return
                }

                Task { @MainActor in
                    isHandInFrame = true
                    isGatheringObservations = true
                }

                let poseMultiArray = try observation.keypointsMultiArray()
                //print(try observation.recognizedPoints(forGroupKey: VNRecognizedPointGroupKey.all))
                let VNHLKITIP = try observation.recognizedPoint(forKey: VNRecognizedPointKey(rawValue: "VNHLKITIP"))
                let VNHLKTTIP = try observation.recognizedPoint(forKey: VNRecognizedPointKey(rawValue: "VNHLKTTIP"))
                print (VNHLKITIP.x - VNHLKTTIP.x)
                print (VNHLKITIP.y - VNHLKTTIP.y)
                
                let input = HandPoseInput(poses: poseMultiArray)

                guard let output = try mlModel.predict(poses: input) else { return }
                await updatePredictions(output: output)
                await checkIfReadyForNextStep()
                //let jointPoints = try gatherHandPosePoints(from: observation)
                //await updateNodes(points: jointPoints)
            } catch {
                print("Error performing request: \(error)")
            }
        }
        
    }
    
    func updateMLModel(with model: NSObject) {
        guard let mlModel = model as? HandPoseMLModel else { return }
        camera.currentMLModel = mlModel
    }

}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
