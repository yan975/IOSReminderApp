//
//  model.swift
//  Record & Remind
//
//  Created by Yan Pinglan on 4/1/22.
//

import Foundation
import UserNotifications

var myEncoder = JSONEncoder()
var myDecoder = JSONDecoder()

let notiContent = UNMutableNotificationContent()

class Tasks: ObservableObject {
    @Published var taskList:[singleTask]
    var count = 0
    
    init() {
        self.taskList = []
    }
    
    init(data: [singleTask]) {
        self.taskList = []
        for x in data {
            self.taskList.append(singleTask(title: x.title, ddlDate: x.ddlDate, id: self.count))
            count += 1
        }
    }
    
    func addEvent(data: singleTask) {
        self.taskList.append(singleTask(title: data.title, ddlDate: data.ddlDate, id: self.count))
        self.count += 1
        self.sortByTime()
        self.dataStorage()
        self.sendNoti(id: self.taskList.count - 1)
    }
    
    func edit(id: Int, data: singleTask) {
        self.withdrawNoti(id: id)
        self.taskList[id].title = data.title
        self.taskList[id].ddlDate = data.ddlDate
        self.sortByTime()
        self.dataStorage()
        self.sendNoti(id: id)
    }
    
    func sortByTime() {
        self.taskList.sort(by: {(a, b) in
            return a.ddlDate.timeIntervalSince1970 < b.ddlDate.timeIntervalSince1970
        })
        for i in 0..<self.taskList.count {
            self.taskList[i].id = i
        }
    }
    
    func removeEvent(id: Int) {
        self.withdrawNoti(id: id)
        self.taskList[id].isRemove = true
        self.sortByTime()
        self.dataStorage()
    }
    
    func dataStorage() {
        let storedDate = try! myEncoder.encode(self.taskList)
        UserDefaults.standard.set(storedDate, forKey: "taskList")
    }
    
    func sendNoti(id: Int) {
        notiContent.title = self.taskList[id].title
        notiContent.sound = UNNotificationSound.default
        let tInterval = self.taskList[id].ddlDate.timeIntervalSinceNow
        if (tInterval > 0) {
            let myTrigger = UNTimeIntervalNotificationTrigger(timeInterval: tInterval, repeats: false)
            let myRequest = UNNotificationRequest(identifier: self.taskList[id].title + self.taskList[id].ddlDate.description, content: notiContent, trigger: myTrigger)
            
            UNUserNotificationCenter.current().add(myRequest)
        } else {
            print(tInterval)
        }
    }
    
    func withdrawNoti(id: Int) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [self.taskList[id].title + self.taskList[id].ddlDate.description])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.taskList[id].title + self.taskList[id].ddlDate.description])
    }
}

struct singleTask: Identifiable, Codable {
    var title: String = ""
    var ddlDate: Date = Date()
    var id: Int = 0
    var isRemove = false
}
