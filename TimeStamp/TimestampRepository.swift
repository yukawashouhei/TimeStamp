//
//  TimestampRepository.swift
//  TimeStamp
//
//  Created by 湯川昇平 on 2025/10/04.
//

import Foundation
import RealmSwift
import Combine // Combineフレームワークをインポート

// Repositoryの「仕事内容」を定義する(Interface)
protocol TimestampRepository{
    func timestampsPublisher() -> AnyPublisher<[Timestamp], Never>
    func addTimestamp()
    func deleteTimestamps(ids: [String])
}

// Realmを使って仕事内容を「具体的」に実装する(Implementation)
class RealmTimestampRepository: TimestampRepository {
    // より安全なRealm初期化
    private lazy var realm: Realm = {
        do {
            return try Realm()
        } catch {
            print("❌ Realm Initialization failed: \(error)")
            // デフォルト設定で再試行
            let config = Realm.Configuration(
                deleteRealmIfMigrationNeeded: true
            )
            do {
                return try Realm(configuration: config)
            } catch {
                // 最終手段: インメモリRealm
                let memoryConfig = Realm.Configuration(inMemoryIdentifier: "backup")
                return try! Realm(configuration: memoryConfig)
            }
        }
    }()
    
    private var notificationToken: NotificationToken?
    
    // deinitでメモリリーク防止
    deinit {
        notificationToken?.invalidate()
    }
    
    // Combineを使って、データベースの変更をリアルタイムで通知する
    func timestampsPublisher() -> AnyPublisher<[Timestamp], Never> {
        let publisher = PassthroughSubject<[Timestamp], Never>()
        
        let results = realm.objects(TimestampObject.self).sorted(byKeyPath: "createdAt", ascending: false)
        
        notificationToken = results.observe { [weak publisher] _ in
            guard let publisher = publisher else { return }
            let timestamps = results.map { $0.toDomainObject() }
            publisher.send(Array(timestamps))
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    // 新しいタイムスタンプを追加する
    func addTimestamp() {
        let newTimestamp = TimestampObject()
        newTimestamp.date = Date()
        newTimestamp.createdAt = Date()
        
        do {
            try realm.write {
                realm.add(newTimestamp)
            }
        } catch {
            print("❌ Failed to add timestamp: \(error)")
        }
    }
    
    // 指定されたIDのタイムスタンプを削除する
    func deleteTimestamps(ids: [String]) {
        let objectIds = ids.compactMap { try? ObjectId(string: $0) }
        let objectsToDelete = realm.objects(TimestampObject.self).filter("id IN %@", objectIds)
        
        guard !objectsToDelete.isEmpty else { return }
        
        do {
            try realm.write {
                realm.delete(objectsToDelete)
            }
        } catch {
            print("❌ Failed to delete timestamps: \(error)")
        }
    }
}
