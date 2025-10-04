//
//  TimestampRow.swift
//  TimeStamp
//
//  Created by  on 2025/09/09.
//

import SwiftUI
import RealmSwift

struct TimestampRow: View {
    //RealmのTimestampObjectを受け取るように修正
    let item: TimestampObject
    
    private static let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        HStack {
            Image(systemName: "calendar.badge.clock")
                .foregroundColor(.pink)
            VStack(alignment: .leading) {
                // item.dateは必ず存在するので、if letは不要
                Text(Self.dateFormatter.string(from: item.date))
                    .fontWeight(.semibold)
                
                // item.createdAtは必ず存在するので、if letは不要
                Text("Saved: \(item.createdAt.formatted(.relative(presentation: .named)))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    // プレビュー用に、ダミーのTimestampObjectを生成
    let dummyItem = TimestampObject()
    dummyItem.date = Date()
    dummyItem.createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    
    return TimestampRow(item: dummyItem)
        .padding() // プレビューが見えやすくなるように余白を追加
}
