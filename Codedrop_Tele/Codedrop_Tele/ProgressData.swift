
import Foundation
import SwiftData

@Model
class ProgessData: Identifiable {
    
    @Attribute(.unique) var id = UUID()
    
    var nowProgressValue: Double
    var totalProgessValue: Double
    
    init(nowProgressValue: Double, totalProgessValue: Double) {
        self.nowProgressValue = nowProgressValue
        self.totalProgessValue = totalProgessValue
    }
}
