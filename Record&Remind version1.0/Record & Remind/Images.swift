//
//  Image.swift
//  Record & Remind
//
//  Created by Kaixuan Tang on 4/30/22.
//
import SwiftUI
import UIKit

struct Images: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Images>) -> UIImagePickerController {
        
        let images = UIImagePickerController()
        images.allowsEditing = false
        images.sourceType = sourceType
        images.delegate = context.coordinator
        return images
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var temp: Images
        
        init(_ temp: Images) {
            self.temp = temp
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                temp.selectedImage = image
            }
            temp.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
