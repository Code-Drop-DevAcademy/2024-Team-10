
import SwiftUI
import SwiftData

struct BadTaskView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var BadTasks: [TaskBadData]

    @State var showModal: Bool = false

    var body: some View {
        NavigationStack {
            HStack(spacing: 0) {
                Text("이거 완전 럭키비키잖아?")
                    .foregroundColor(.black)
                    .font(.system(size: 22, weight: .bold))
                    .padding(16)

                Spacer()
            }

            ZStack {
                ScrollView {
                    ForEach(BadTasks.reversed(), id: \.id) { task in
                        NavigationLink(destination: DetailBadTaskView(task: task)) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("🍀" + task.taskBadDate.toFormattedString())
                                    .foregroundColor(.black)
                                    .font(.system(size: 17, weight: .bold))
                                    .padding(.top, 16)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 6)

                                Text(task.taskBadContent )
                                    .foregroundColor(.black)
                                    .lineLimit(3)
                                    .frame(width: 321, height: 66, alignment: .leading)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)

                            }
                            .frame(height: 131)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 1)
                                    .stroke(Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.5), lineWidth: 2)

                            )
                            .padding(.vertical, 5)
                        }
                    }

                    Rectangle()
                        .frame(width: 393, height: 158)
                        .foregroundColor(.clear)
                }

                VStack(spacing: 0) {
                    Spacer()
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 393, height: 160)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: .white.opacity(0.3), location: 0.00),
                                        Gradient.Stop(color: .white, location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 0.34)
                                )
                            )

                        Button(action: {
                            showModal = true
                        }, label: {
                            Text("럭키비키 쓰러가기")
                                .font(.system(size: 17, weight: .heavy))
                                .padding(.horizontal, 58)
                                .padding(.vertical, 16)
                                .background(Color(UIColor.systemGreen))
                                .foregroundColor(.white)
                                .cornerRadius(30)
                                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                        })
                        .padding(EdgeInsets(top: 65, leading: 77, bottom: 43, trailing: 77))
                    }

                }
            }.sheet(isPresented: self.$showModal) {
                BadTaskWriteModalView(showModal: $showModal)
            }
        }
//        .padding(16)
    }
}

#Preview {
    BadTaskView()
}

