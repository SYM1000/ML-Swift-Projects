//
//  ImagePicker.swift
//  ImageClassificationCustomDSCamera
//
//  Created by Mohammad Azam on 2/6/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, sourceType: sourceType, isShown: $isShown)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> ImagePicker.UIViewControllerType {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    let sourceType: UIImagePickerController.SourceType
    
    init(image: Binding<UIImage?>, sourceType: UIImagePickerController.SourceType, isShown: Binding<Bool>) {
        _image = image
        _isShown = isShown
        self.sourceType = sourceType
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = uiImage 
        isShown = false
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
    
}
