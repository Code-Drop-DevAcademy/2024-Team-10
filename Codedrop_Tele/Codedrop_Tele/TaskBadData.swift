
import Foundation
import SwiftData

@Model
class TaskBadData: Identifiable {
    
    @Attribute(.unique) var id = UUID()

    var taskBadContent: String
    var taskBadDate: Date
    
   
    init(taskBadContent: String, taskBadDate: Date) {
        self.taskBadContent = taskBadContent
        self.taskBadDate = taskBadDate
    }
    
}
