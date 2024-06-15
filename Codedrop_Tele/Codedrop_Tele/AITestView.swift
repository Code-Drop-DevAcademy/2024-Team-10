//
//  AITestView.swift
//  Codedrop_Tele
//
//  Created by hanseoyoung on 6/15/24.
//

import SwiftUI
import GoogleGenerativeAI

struct AITestView: View {
    @State var userPrompt = ""
    @State var response: LocalizedStringKey = "럭키비키럭키비키"
    @State var isLoading = false

    var body: some View {
        VStack {
            Text("AI Test를 위한 View")
                .font(.largeTitle)
                .foregroundStyle(.indigo)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            ZStack{
                ScrollView{
                    Text(response)
                        .font(.title)
                }
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                        .scaleEffect(4)
                }

            }

            TextField("Ask anything...", text: $userPrompt, axis: .vertical)
                .lineLimit(5)
                .font(.title3)
                .padding()
                .background(Color.indigo.opacity(0.2), in: Capsule())
                .disableAutocorrection(true)
                .onSubmit {
                    generateResponse()
                }


        }
        .padding()
    }

    func generateResponse(){
        isLoading = true;
        response = ""

        Task {
            do {
                let result = try await chat.sendMessage(userPrompt)
                isLoading = false
                response = LocalizedStringKey(result.text ?? "No response found")
                userPrompt = ""
            } catch {
                response = "Something went wrong! \n\(error.localizedDescription)"
            }
        }
    }
}
