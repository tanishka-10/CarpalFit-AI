import SwiftUI

struct ExcerciseModel: Hashable, Equatable {
    private var excerciseId: String
    private var name: String
    
    init(excerciseId: String, name: String) {
        self.excerciseId = excerciseId
        self.name = name
    }
    
    func getExcerciseId() -> String{
        return self.excerciseId;
    }
    
    func getName() -> String{
        return self.name;
    }
}
