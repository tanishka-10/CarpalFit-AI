import SwiftUI

struct CameraView: View {
    @EnvironmentObject var appModel: ApplicationModel
    var showNodes: Bool = true
    
//    private var showWarning: Bool {
//        appModel.viewfinderImage != nil && appModel.currentMLModel != nil && !appModel.isHandInFrame
//    }
    
    private var previewImageSize: CGSize {
        appModel.camera.previewImageSize
    }
    
//    private var handJointPoints: [CGPoint] {
//        appModel.nodePoints
//    }
    
    var body: some View {
        ViewfinderView(image: $appModel.viewfinderImage)
            .overlay(alignment: .center)  {
//                if showNodes {
//                    HandPoseNodeOverlay(size: previewImageSize,
//                                        points: handJointPoints)
//                }
            }
            .overlay(alignment: .center) {
                if true {
                    CameraFrameOverlay()
//                        .animation(.default, value: appModel.isHandInFrame)
                }
            }
            .task {
                await appModel.camera.start()
            }
            .onReceive(appModel.predictionTimer) { _ in
                //guard appModel.currentMLModel != nil else { return }
               DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                      appModel.canPredict = true
//                      appModel.StepIndex = 1
               }
            }
            .onDisappear {
                appModel.canPredict = false
            }
    }
}

//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView(showNodes: true)
//            .environmentObject(ApplicationModel())
//    }
//}
