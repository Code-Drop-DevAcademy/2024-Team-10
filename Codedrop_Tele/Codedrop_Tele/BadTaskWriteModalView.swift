//
//  BadTaskWriteModalView.swift
//  Codedrop_Tele
//
//  Created by hanseoyoung on 6/15/24.
//

import SwiftUI
import SwiftData
import GoogleGenerativeAI

struct BadTaskWriteModalView: View {

    @Environment(\.modelContext) var modelContext

    @Binding var showModal: Bool
    @State private var content: String = ""
    @State var isLoading = false

    var todayDate = Date()
    @State var response: LocalizedStringKey = ""

    var body: some View {
        VStack {
            HStack {
                Text("오늘 일하면서 \n힘들었던 일이 있나요?")
                    .font(.system(size: 28))
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                Spacer()
            }

            ZStack(alignment: .topLeading) {
                TextEditor(text: $content)
                    .frame(height: 200)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )

                if content.isEmpty {
                    Text("내용을 입력해주세요.")
                        .foregroundColor(.gray)
                        .padding(.top, 23)
                        .padding(.leading, 20)
                }
            }


            HStack {
                Button(action: {
                    if !isLoading {
                        generateResponse()
                    }
                }) {
                    Text(isLoading ? "로딩중..." : "작성완료")
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                        .padding(.horizontal, 80)
                        .padding(.vertical, 14)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(30)
                }
            }
            .padding(.all, 20)
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

            Spacer()
        }
        .padding()
    }

    private func saveData() {
        let newTask = TaskBadData(taskBadContent: response.toString(), taskBadDate: todayDate)
        modelContext.insert(newTask)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }

    func generateResponse(){
        isLoading = true;
        response = ""

        Task {
            do {
                let result = try await chat.sendMessage(content)
                isLoading = false
                response = LocalizedStringKey(result.text ?? "No response found")
                saveData()
                showModal = false
            } catch {
                response = "Something went wrong! \n\(error.localizedDescription)"
            }
        }
    }
}

extension LocalizedStringKey {
    func toString() -> String {
        let mirror = Mirror(reflecting: self)
        let children = mirror.children
        if let value = children.first(where: { $0.label == "key" })?.value as? String {
            return value
        } else {
            return ""
        }
    }
}
