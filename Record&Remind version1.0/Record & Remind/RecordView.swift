//
//  RecordView.swift
//  Record & Remind
//
//  Created by Kaixuan Tang on 4/30/22.
//

import SwiftUI

struct RecordView: View {
    
    @ObservedObject var taskData: Tasks = Tasks(data: initUserData())
    
    var body: some View {
        VStack {
            
            Text("Image")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Photofunc()
        }.frame(width: 370)
    }
}



struct Photofunc: View {
    
    @State var openPhotos = false
    @State var showImage = false
    @State var imageSlected = UIImage()
    var body: some View {
        ZStack {
            Button(action: editf1) {
                if showImage {
                    Image (uiImage: imageSlected)
                        .resizable()
                        .frame(width:370,height: 370)
                        .padding()
                } else {
                    Image (systemName: "camera")
                        .resizable()
                        .frame(width:50, height: 40)
                        .padding()
                }
            }
        }.sheet(isPresented: $openPhotos) {
            Images(selectedImage: $imageSlected, sourceType: .camera)
        }
    }
    
    func editf1() {
        showImage = true
        openPhotos = true
    }
}


struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
