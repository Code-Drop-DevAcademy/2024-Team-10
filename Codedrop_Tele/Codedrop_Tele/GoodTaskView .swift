import SwiftUI
import SwiftData

struct GoodTaskView: View {
    
    @State private var progress: Double = 0.0 // 현재 프로그레스바 Value
    @State private var maxProgess: Double = 2.0 // 언락까지 프로그레스바 Total Value
    @State private var showModal = false // 모달 표시 여부
    @State private var showGridItemView = false // GridItemView 표시 여부
    
    @Environment(\.modelContext) var modelContext
    @Query private var goodTasks: [TaskGoodData]
    @Query private var progressData: [ProgessData]
    
    @State private var isAlertPresented = false
    @State private var selectedTask: TaskGoodData?
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        
                        HStack {
                            Text("곧 잠금이 풀려요!")
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .padding(.leading)
                                .padding(.top)
                            
                            Spacer()
                        }
                        HStack {
                            Text("\(Int(maxProgess - progress))개만 더 작성해주세요!")
                                .font(.system(size: 24))
                                .padding(.leading)
                                .padding(.top, 2)
                            
                            Spacer()
                        }
                        
                        CustomProgressView(currentProgress: $progress, maxProgess: $maxProgess)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(goodTasks) { task in
                                if showGridItemView {
                                    GridItemView(goodTasks: task)
                                                                           .onTapGesture {
                                                                               selectedTask = task
                                                                               isAlertPresented.toggle()
                                                                           }
                                } else {
                                    VStack{
                                        Spacer()
                                        HStack{
                                            ZStack{
                                                Circle()
                                                    .frame(width: 80, height: 80)
                                                    .foregroundColor(.gray.opacity(0.1))
                                                //.foregroundColor(Color(hex:"#B3E5FF"))
                                                
                                                Image("Lockicons")
                                                    .font(.system(size:60))
                                                    .multilineTextAlignment(.center)
                                                    .frame(height: 22, alignment: .center)
                                            }
                                        }
                                        Spacer()
                                        HStack{
                                            Text("\(formattedDate())")
                                        }
                                        .padding(.bottom)
                                    }
                                    .frame(minHeight: 180)
                                    .frame(maxWidth: .infinity)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                                    )
                                }
                                //                                else {
                                //                                    Color.yellow.frame(height:180)
                                //                                }
                                
                            }
                        }
                        .padding()
                        
                        
                        Spacer()
                    }
                }
                VStack(spacing: 0) {
                    Spacer()
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 393, height: 160)
                        //                            .background(
                        //                                LinearGradient(
                        //                                    stops: [
                        //                                        Gradient.Stop(color: .white.opacity(0.3), location: 0.00),
                        //                                        Gradient.Stop(color: .white, location: 1.00),
                        //                                    ],
                        //                                    startPoint: UnitPoint(x: 0.5, y: 0),
                        //                                    endPoint: UnitPoint(x: 0.5, y: 0.34)
                        //                                )
                        //                            )
                        
                        Button(action: {
                            showModal.toggle()
                        }, label: {
                            Text("워키비키 쓰러가기")
                                .font(.system(size: 17, weight: .heavy))
                                .padding(.horizontal, 58)
                                .padding(.vertical, 16)
                                .background(Color(UIColor.systemGreen))
                                .foregroundColor(.white)
                                .cornerRadius(30)
                                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4) // Shadow with offset
                            
                        })
                        .padding(EdgeInsets(top: 65, leading: 50, bottom: 43, trailing: 50))
                        .sheet(isPresented: self.$showModal) {
                            ModalView(progress: $progress, maxProgress: $maxProgess, showGridItemView: $showGridItemView)
                        }
                    }
                }
                
            }
           
        }
        .overlay {
            if isAlertPresented, let task = selectedTask { // Check if selectedTask is not nil
                CustomAlertView(isPresented: $isAlertPresented, goodTasks: task)
            }
        }
        //.padding(16)
        
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: Date())
    }
}

// MARK: 커스텀 Alert
struct CustomAlertView: View {
    
    @Binding var isPresented: Bool
    let goodTasks: TaskGoodData
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Text("☘️")
                        .font(.system(size: 100))
                        .padding(.bottom, 20)
                    
                    
                    Text(formattedDate(goodTasks.taskGoodDate))
                        .padding(.bottom, 20)
                    
                    Text(goodTasks.taskGoodTitle)
                        .bold()
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                    
                    Text(goodTasks.taskGoodContent)
                }
                .padding(.vertical, 60)
                
                Button("닫기") {
                    isPresented.toggle()
                }
                .bold()
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGreen))
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(.top, 10)
                .padding(.bottom, 20)
                .padding(.horizontal, 80)
            }
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal, 20) // Adjusted padding for a larger width
            
        }
    }
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
}


// MARK: Task 작성 모달
struct ModalView: View {
    
    @Environment(\.presentationMode) var presentation
    @Environment(\.modelContext) var modelContext
    
    @Binding var progress: Double
    @Binding var maxProgress: Double
    @Binding var showGridItemView: Bool
    
    @State private var title: String = ""
    @State private var content: String = ""
    var today = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("워키비키 작성")
                        .font(.largeTitle)
                    Spacer()
                }
                
                HStack {
                    Text("제목")
                        .bold()
                        .padding()
                    
                    TextField("제목을 입력해주세요.", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing)
                }
                
                HStack {
                    Text("내용을 입력해주세요. ")
                    Spacer()
                }
                
                TextEditor(text: $content)
                    .frame(height: 200)
                    .padding()
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                
                HStack {
                    Button(action: {
                        // 저장 액션 등 필요한 로직 구현
                        let post = TaskGoodData(taskGoodTitle: title, taskGoodContent: content, taskGoodDate: today)
                        modelContext.insert(post)
                        
                        // 직접 접근하여 progress 및 maxProgress 업데이트
                        self.progress += 1.0
                        if self.progress >= self.maxProgress {
                            self.progress = 0.0
                            self.showGridItemView = true
                            self.maxProgress += 1.0
                        }
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("작성완료")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal, 35)
                    }
                    .padding()
                }
                .frame(maxWidth: 200)
                .frame(height: 20)
                .padding()
                .background(Color(UIColor.systemGreen))
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(trailing:
                                    Button(action: {
                self.presentation.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            )
        }
    }
}

// MARK: 프로그레스 바
struct CustomProgressView: View {
    
    @Binding var currentProgress: Double
    @Binding var maxProgess: Double
    
    var body: some View {
        VStack{
            ProgressView(value: currentProgress, total: maxProgess)
                .progressViewStyle(LinearProgressViewStyle(tint: Color(UIColor.systemGreen)))
                .scaleEffect(CGSize(width: 1.0, height: 3.0))
                .padding()
        }
    }
}

// MARK: 리스트 Cell View
struct GridItemView: View {
    
    let goodTasks: TaskGoodData
    @State private var usedEmojis: Set<String> = []
    private let emojis = ["☘️", "🦖", "🌱","💚"]
    
    // Function to generate a random color
    func randomColor() -> Color {
        let colors: [Color] = [.blue, .green, .red, .orange, .purple, .yellow]
        return colors.randomElement() ?? .gray // Default to gray if no color is selected
    }
    
    var body: some View {
        VStack {
            HStack{
                dateBadge(date: goodTasks.taskGoodDate)
                Spacer()
            }
            
            HStack{
                titleBadge(title: goodTasks.taskGoodTitle)
                Spacer()
            }
            
            HStack{
                contentBadge(contents: goodTasks.taskGoodContent)
                Spacer()
            }
            Spacer()
            HStack{
                Spacer()
                emojiBadge()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180)
        .background(randomColor().opacity(0.3)) // Apply random color here
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.4), lineWidth: 2)
        )
    }
    
    // 날짜
    func dateBadge(date: Date) -> some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: date)
        
        return ZStack {
            Rectangle()
                .frame(width: 80, height: 22)
                .foregroundColor(Color.gray.opacity(0.1))
            //.foregroundColor(Color(hex:"#B3E5FF"))
                .cornerRadius(10)
            
            Text(dateString)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .frame(height: 22, alignment: .center)
        }
    }
    
    // 제목
    func titleBadge(title: String) -> some View {
        
        return ZStack {
            
            Text(title)
                .multilineTextAlignment(.center)
                .bold()
                .frame(height: 22, alignment: .center)
        }
    }
    
    // 내용
    func contentBadge(contents: String) -> some View {
        
        return ZStack {
            
            Text(contents)
                .multilineTextAlignment(.center)
                .frame(height: 22, alignment: .center)
        }
    }
    
    // 축하뱃지
     func emojiBadge() -> some View {
         var emojisToUse = emojis.shuffled()
         
         if emojisToUse.isEmpty {
             emojisToUse = emojis.shuffled()
         }
         
         let randomEmoji = emojisToUse.removeLast()
         
         return ZStack {
             Text(randomEmoji)
                 .font(.system(size: 60))
                 .multilineTextAlignment(.center)
                 .frame(height: 22, alignment: .center)
                 .padding(.bottom)
         }
     }
}

// MARK: Lock Cell View
struct LockItemView: View {
    
    let goodTasks: TaskGoodData
    
    var body: some View {
        VStack {
            Spacer()
            HStack{
                emojiBadge()
            }
            Spacer()
            HStack{
                dateBadge(date: goodTasks.taskGoodDate)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180)
        //        .background(Color.blue.opacity(0.3))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.4), lineWidth: 2)
        )
    }
    // 축하뱃지
    func emojiBadge() -> some View {
        
        return ZStack {
            
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue.opacity(0.1))
            //.foregroundColor(Color(hex:"#B3E5FF"))
            
            Text("🔒")
                .font(.system(size:60))
                .multilineTextAlignment(.center)
                .frame(height: 22, alignment: .center)
                .padding(.bottom)
        }
    }
    
    func dateBadge(date: Date) -> some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: date)
        
        return ZStack {
            
            Text(dateString)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .frame(height: 22, alignment: .center)
            
        }
    }
    
}

#Preview {
    GoodTaskView()
}
