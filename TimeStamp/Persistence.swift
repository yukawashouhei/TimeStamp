

import CoreData

struct PersistenceController {
    //　アプリ全体で共有されるシングルトンインスタンス
    static let shared = PersistenceController()
    
    // プレビュー用のインメモリ (えいzokukasinai)　コンテナ
    static var preview: PersistenceController {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        //プレビュー用のダミーデータを10個作成
        for i in 0..<10 {
            let newItem = TimestampItem(context: viewContext)
            newItem.id = UUID()
            newItem.createdAt = Date().addingTimeInterval(Double(-i * 3600)) // 1時間ずつ過去のデータを作成
            newItem.date = newItem.createdAt
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError),\(nsError.userInfo)")
        }
        return result
    }
    
    // Core Dataの永続コンテナ
    let container: NSPersistentContainer
    
    // 初期化処理
    init(inMemory: Bool = false) {
        // "TimeStamp"は.xcdatamodeld ファイルの名前と一致させる
        container = NSPersistentContainer(name: "TimeStamp")
        if inMemory {
            // inMemoryがtrueの場合、データを永続化せずメモリ上でのみ扱う(主にプレビュー用)
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription,error) in
            if let error = error as NSError? {
                // ここは本番アプリでは適切なエラーハンドリングに置き換えるべき
                fatalError("Unresolved error \(error),\(error), \(error.userInfo))")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
