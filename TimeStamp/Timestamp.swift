//
//  Timestamp.swift
//  TimeStamp
//
//  Created by 湯川昇平 on 2025/10/05.
//

import Foundation

// ドメイン層のTimestampモデル(Realmに依存しない純粋なデータ)
struct Timestamp: Identifiable {
    let id: String   // ObjectIdを文字列で保持
    let date: Date   // タップされた日時
    let createdAt: Date   //作成日時
}
