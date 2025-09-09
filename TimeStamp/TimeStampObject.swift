//
//  TimeStampObject.swift
//  TimeStamp
//
//  Created by 湯川昇平 on 2025/09/07.
//

import Foundation
import RealmSwift

class TimestampObject: Object, Identifiable {
    // `Persistedは、Realmに「このデータを保存してください」とお願いする目印
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date = Date()
    @Persisted var createdAt: Date = Date()
}
