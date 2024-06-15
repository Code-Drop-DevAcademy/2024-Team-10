import SwiftUI

struct TabbarControlView: View {
    var body: some View {
        TabView {
            GoodTaskView()
                .tabItem {
                    VStack {
                        Image("Worky")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .aspectRatio(contentMode: .fit)
                        Text("워키비키")
                    }
                }
            BadTaskView()
                .tabItem {
                    VStack {
                        Image("Lucky")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("럭키비키")
                    }
                }
        }
    }
}

#Preview {
    TabbarControlView()
}
