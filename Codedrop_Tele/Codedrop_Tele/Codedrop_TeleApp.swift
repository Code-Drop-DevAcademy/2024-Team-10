
import SwiftUI
import SwiftData

@main
struct Codedrop_TeleApp: App {
    
    var modelContainer: ModelContainer = {
        let schema = Schema([TaskGoodData.self, TaskBadData.self, ProgessData.self])
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema,
                                      configurations: [modelConfiguration])
        } catch {
            fatalError("modelContainer가 생성되지 않았습니다: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            TabbarControlView()
                .modelContainer(modelContainer)
        }
    }
}
