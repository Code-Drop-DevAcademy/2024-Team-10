
import Foundation
import SwiftData

@Model
class TaskGoodData: Identifiable {
    
    @Attribute(.unique) var id = UUID()
    
    var taskGoodTitle: String
    var taskGoodContent: String
    var taskGoodDate: Date
    
    init(taskGoodTitle: String, taskGoodContent: String, taskGoodDate: Date) {
        self.taskGoodTitle = taskGoodTitle
        self.taskGoodContent = taskGoodContent
        self.taskGoodDate = taskGoodDate
    }
}
