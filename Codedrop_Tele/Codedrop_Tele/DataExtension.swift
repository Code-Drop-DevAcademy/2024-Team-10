//
//  DataExtension.swift
//  Codedrop_Tele
//
//  Created by hanseoyoung on 6/15/24.
//

import Foundation


extension Date {
    func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
