//
//  DetailBadTaskView.swift
//  Codedrop_Tele
//
//  Created by hanseoyoung on 6/15/24.
//

import SwiftUI

struct DetailBadTaskView: View {
    let task: TaskBadData
    var body: some View {
        ZStack {
            Image("LuckyLine")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack(spacing: 0) {
                Text(task.taskBadDate.toFormattedString() + "의 럭키비키")
                    .font(.system(size: 22, weight: .bold))
                    .padding(.top, 68)

                ScrollView {
                    Text(task.taskBadContent)
                        .font(.system(size: 20, weight: .regular))
                }
                .frame(width: 259, height: 300)
                .padding(EdgeInsets(top: 36, leading: 52, bottom: 91, trailing: 51))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 83)
        .padding(.bottom, 108)
    }
}

#Preview {
    DetailBadTaskView(task: .init(taskBadContent: "", taskBadDate: Date()))
}
