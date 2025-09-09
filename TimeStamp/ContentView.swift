//
//  ContentView.swift
//  TimeStamp
//
//  Created by on 2025/08/13.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    // MARK: - Properties
    
    // RealmのデータベースからTimestampObjectを全て取得し、createdAtの降順で並べ替える
    @ObservedResults(TimestampObject.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var items
    
    //ツールバーと中央に表示する日時を管理するための状態変数
    @State private var currentDate = Date()
    @State private var tappedDate: Date? // ボタンをタップされた時刻(タップされるまではnil)
    
    // 1秒ごとにcurrentDateを更新するためのタイマー
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                Spacer()
                
                // 2. ボタンタップで中央に時刻を表示
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
                        TimestampRow(item: item)
                    }
                    .onDelete(perform: deleteItems) // スワイプで削除する機能を追加
                }
                .listStyle(.plain) // リストのスタイルをシンプルに
                .navigationTitle("TimeStamp App") // ナビゲーションのタイトル
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(currentDate, format: .dateTime.year().month().day().weekday().hour().minute().second())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .onReceive(timer) { inputDate in
                                self.currentDate = inputDate
                            }
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Realm Functions
    /// 3. Realmsに新しいタイムスタンプを保存する
    private func addItem() {
        let newItem = TimestampObject()
        newItem.date = self.tappedDate ?? Date()
        newItem.createdAt = Date() //　作成日時
        
        // $items.append(newItem)は、取得したデータ(items)に新しい項目を追加し、
        //自動的にデータベースにも書き込んでくれる便利な書き方
        $items.append(newItem)
    }
    
    /// リストからアイテムを削除する
    private func deleteItems(offsets: IndexSet) {
        // anObservableResults.remove(atOffsets:)でスワイプされた行のデータを削除する
        $items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
