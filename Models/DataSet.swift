import SwiftUI

final class Dataset: ObservableObject, Identifiable {
    @Published var name: String
    let type: DatasetType
    let steps: [String]
    var resourceDirectory: URL?
    
    init(name: String? = nil, type: DatasetType, steps: [String], resourceDirectory: URL? = nil, isNew: Bool = false) {
        self.name = name ?? "New Dataset"
        self.type = type
        self.steps = steps
    }
}

enum DatasetType: String {
    case training
    case validation
}
