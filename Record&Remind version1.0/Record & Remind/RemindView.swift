//
//  ContentView.swift
//  Record & Remind
//
//  Created by Yan Pinglan on 3/18/22.
//

import SwiftUI

var df = DateFormatter()

func initUserData() -> [singleTask] {
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var temp: [singleTask] = []
    if let storedData = UserDefaults.standard.object(forKey: "taskList") as? Data {
        let data = try! myDecoder.decode([singleTask].self, from: storedData)
        for x in data {
            if !x.isRemove {
                temp.append(singleTask(title: x.title, ddlDate: x.ddlDate, id: temp.count))
            }
        }
    }
    return temp
}

struct RemindView: View {
    
    @ObservedObject var taskData: Tasks = Tasks(data: initUserData())
    
     var body: some View {
         VStack{
             NavigationView {
                 ScrollView(.vertical, showsIndicators: true) {
                     ForEach(self.taskData.taskList, id: \.id) { x in
                         /*SingleRemainder(title: x.title, setDate: x.ddlDate*/
                         if !x.isRemove {
                             SingleRemainder(index: x.id)
                                 .environmentObject(self.taskData)
                                 .frame(width: 370)
                                 .padding()
                         }
                     }
                     .frame(width: 370)
                 }.navigationTitle("Reminder")
             }
            
            //Photofunc()
            Addfunc(taskDataTemp: taskData)
         }
         .frame(width: 370)
    }
}


struct SingleRemainder: View {
    @EnvironmentObject var taskData: Tasks
    //@State var title: String = ""
    //@State var notrText: String = String()
    //@State var buttonRemainder = "Add Remainders"
    //@State var buttonImage = "Add Image"
    //@State var textRemainder: String = ""
    //@State var setDate: Date = Date()
    var index: Int
    @State var isShown = false
    
    var body: some View {
        
        HStack {
            Rectangle()
                .frame(width: 20.0, height: 80.0, alignment: .leading)
                .foregroundColor(.blue)
                
            Button(action: {self.isShown = true}) {
                Group {
                    VStack(alignment: .leading, spacing: 6.0) {
                        Text(self.taskData.taskList[index].title)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            //Text(buttonRemainder)
                        Text(df.string(from: self.taskData.taskList[index].ddlDate))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading)
                    Spacer()
                }
            }
            .sheet(isPresented: self.$isShown, content: {
                edit(title: self.taskData.taskList[self.index].title, ddlDate: self.taskData.taskList[self.index].ddlDate, id: self.index)
                    .environmentObject(self.taskData)
            })
            
            Button(action: {self.taskData.removeEvent(id: self.index)}) {
                Image(systemName: "minus.circle")
                    .imageScale(.large)
                    .padding(.trailing)
            }
            
        }
        .frame(width: 360, height: 80)
        .background(Color.white)
        .cornerRadius(8.0).shadow(color: .gray, radius: 5.0, x: 5.0, y: 5.0)
        .padding(.horizontal)
    }
}

struct Addfunc: View {
    @State var editFlag = false
    @ObservedObject var taskDataTemp: Tasks
    
    var body: some View {
        VStack {
            Button(action: addf1) {
                Image (systemName: "plus.circle")
                    .resizable()
                    .frame(width:50, height: 50)
                    .padding()
            }.sheet(isPresented: self.$editFlag, content: {
                edit()
                    .environmentObject(self.taskDataTemp)
            })
        }
    }
    
    func addf1() {
        self.editFlag = true
    }
}

struct RemindView_Previews: PreviewProvider {
    static var previews: some View {
        RemindView()
    }
}
