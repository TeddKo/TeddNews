//
//  Date.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/6/25.
//

import Foundation


func formatDisplayDate(from isoString: String) -> String? {
    let isoFormatter = ISO8601DateFormatter()
    
    guard let date = isoFormatter.date(from: isoString) else {
        print("날짜 변환 실패: 입력 형식이 올바르지 않습니다.")
        return nil
    }
    
    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "MMM, dd yyyy"
    displayFormatter.locale = Locale(identifier: "en_US")
    return displayFormatter.string(from: date)
}
