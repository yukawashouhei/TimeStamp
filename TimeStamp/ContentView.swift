//
//  ContentView.swift
//  TimeStamp
//
//  Created by on 2025/08/13.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentDate = Date()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd(E) HH:mm:ss"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text(dateFormatter.string(from:currentDate))
                .font(.system(size:25, weight: .bold, design: .default))
                .foregroundStyle(.primary)
                .onReceive(timer) { inputDate in
                    self.currentDate = inputDate
                }
            
            Button {
                print("Button Tapped at: \(dateFormatter.string(from: currentDate))")
            } label: {
                Label("Time Stamp", systemImage: "clock")
                    .font(.title3)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

