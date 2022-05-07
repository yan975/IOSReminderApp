//
//  edit.swift
//  Record & Remind
//
//  Created by Yan Pinglan on 4/1/22.
//

import SwiftUI

struct edit: View {
    
    @EnvironmentObject var tasks: Tasks
    @Environment(\.presentationMode) var isPresent
    
    @State var title: String = ""
    @State var ddlDate: Date = Date()
    
    var id: Int? = nil
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Event")) {
                    TextField("Add your event here", text: self.$title)
                    DatePicker(selection: self.$ddlDate, label: {Text("Time")})
                }
                
                Section {
                    Button(action: addfunc1) {
                        Text("Add")
                    }
                    Button (action: {self.isPresent.wrappedValue.dismiss()}) {
                        Text("Cancel")
                    }
                }
            }
            .navigationTitle("New Reminder")
        }
    }
    
    func addfunc1() {
        if self.id == nil {
            self.tasks.addEvent(data: singleTask(title: self.title, ddlDate: self.ddlDate))
        } else {
            self.tasks.edit(id: self.id!, data: singleTask(title: self.title, ddlDate: self.ddlDate))
        }
        self.isPresent.wrappedValue.dismiss()
    }
    
}

struct edit_Previews: PreviewProvider {
    static var previews: some View {
        edit()
    }
}
