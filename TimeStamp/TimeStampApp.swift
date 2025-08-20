//
//  TimeStampApp.swift
//  TimeStamp
//
//  Created by 湯川昇平 on 2025/08/13.
//

import SwiftUI

@main
struct TimeStampApp: App {
    // Core Data管理用のコントローラーをインスタンス化
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // SwiftUIの環境にmanagedObjectContextをセットする
            // これにより、どのビューからでもデータベースにアクセスできるようになる
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
