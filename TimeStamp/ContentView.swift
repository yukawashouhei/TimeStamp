//
//  ContentView.swift
//  TimeStamp
//
//  Created by on 2025/08/13.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - Properties
    
    //Core Dataのデータベースにアクセスするための環境変数
    @Environment(\.managedObjectContext) private var viewContext
    
    // Core DataからTimestampItemをフェッチ(取得）するためのリクエスト
    // NSSortDescriptorでcreatedAtを降順(新しいものが上）にソートしている
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TimestampItem.createdAt, ascending: false)],
        animation: .default)
    private var items: FetchedResults<TimestampItem>
    
    //ツールバーと中央に表示する日時を管理するための状態変数
    @State private var currentDate = Date()
    @State private var tappedDate: Date? // ボタンをがタップされた時刻(タップされるまではnil)
    
    // 1秒ごとにcurrentDateを更新するためのタイマー
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                Spacer()
                
                // 2. ボタンタップで中央に時刻を表示
                // tappedDateがnilでない場合のみ、その時刻を表示する
                if let date = tappedDate {
                    Text("Tapped at:")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(date, style: .time)
                        .font(.system(size: 50,weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                // タイムスタンプボタン
                Button {
                    // ボタンがタップされたら、現在時刻を保存する
                    self.tappedDate = Date()
                    addItem()
                } label: {
                    Label("Time Stamp", systemImage: "clock.fill")
                        .font(.title2.bold())
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .controlSize(.large)
                .shadow(radius: 5)
                
                // 4. 保存した時刻をリスト表示
                List {
                    ForEach(items) { item in
                        // リストの改行のビュー
                        TimeStampRow(item: item)
                    }
                    .onDelete(perform: deleteItems) // スワイプで削除する機能を追加
                }
                .listStyle(.plain) // リストのスタイルをシンプルに
                .navigationTitle("TimeStamp App") // ナビゲーションのタイトル
                .navigationBarTitleDisplayMode(.inline)
                // 1. 画面上部左上に現在時刻を表示
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(currentDate, format: .dateTime.year().month().day().weekday().hour().minute().second())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .onReceive(timer) { inputDate in
                                // タイマーで毎秒currentDateを更新
                                self.currentDate = inputDate
                            }
                    }
                }
            }
        }
    }
    
    // MARK: - Core Data Functions
    /// 3. Core Dataに新しいタイムスタンプを保存する
    private func addItem() {
        // withAnimationを使うと、リストに新しい項目が追加される際にアニメーションがつく
        withAnimation {
            let newItem = TimestampItem(context: viewContext)
            newItem.id = UUID()
            newItem.createdAt = Date() //　作成日時
            newItem.date = self.tappedDate // ボタンが押された日時
            
            do {
                try viewContext.save() // 変更をデータベースに保存
            } catch {
                //　エラーハンドリング
                let nsError = error as NSError
                // 本番アプリではユーザーにエラーを追加するなどの処理が望ましい
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    /// リストからアイテムを削除する
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Subviews

///リストの各行を表現するビュー
struct TimeStampRow: View {
    let item: TimestampItem
    
    private static let dateFormatter: DateFormatter = {
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
                if let date = item.date {
                    Text(Self.dateFormatter.string(from: date))
                        .fontWeight(.semibold)
                }
                if let createdAt = item.createdAt {
                    Text("Saved: \(createdAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Preview
}
#Preview {
    ContentView()
    // プレビューでもCore Dataが動作するように、プレビュー用のコンテキストを注入
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
