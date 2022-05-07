//
//  ContentView.swift
//  Record & Remind
//
//  Created by Yan Pinglan on 5/2/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var taskData: Tasks = Tasks(data: initUserData())
    
    var body: some View {
        TabView {
            RemindView().tabItem {
                        Label("Reminder", systemImage: "calendar")
            }
            RecordView().tabItem {
                        Label("Images", systemImage: "photo")
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
