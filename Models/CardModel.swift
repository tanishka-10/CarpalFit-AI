import SwiftUI

class CardModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var imageId: String?
    @Published var imageName: String?
    @Published var isSelected = false
    
    func setImageId(imageId: String) {
        self.imageId = imageId
    }
    
    func getImageId() -> String{
        return self.imageId!
    }
    
    func setImageName(imageName: String) {
        self.imageName = imageName
    }
    
    func getImageName() -> String{
        return self.imageName!
    }
    
    func setIsSelected(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func getIsSelected() -> Bool{
        return self.isSelected
    }
    
    func toggleIsSelected() {
        self.isSelected.toggle()
    }
    
    init(imageId: String, imageName: String) {
        self.imageId = imageId
        self.imageName = imageName
        self.isSelected = false
    }
}
