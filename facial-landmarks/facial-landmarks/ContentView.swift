//
//  ContentView.swift
//  ImageClassificationSwiftUI
//
//

import SwiftUI
import Vision


struct ContentView: View {
    
    let photos = ["face","face2", "friends-sitting", "people-sitting"]
    @State private var currentIndex: Int = 0
    
    @State private var currentImage: UIImage = UIImage(named: "face")!
    
    private func detectFacialLandmarks(completion: @escaping ([VNFaceObservation]?) -> Void) {
        
        guard let cgImage = currentImage.cgImage,
            let orientation = CGImagePropertyOrientation(rawValue: UInt32(currentImage.imageOrientation.rawValue))
        else {
            return
        }
        
        let request = VNDetectFaceLandmarksRequest { (request, error) in
            
            guard let observations = request.results as? [VNFaceObservation] else {
                return completion(nil)
            }
            
            completion(observations)
        }
    
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            Image(uiImage: currentImage)
            .resizable()
                .aspectRatio(contentMode: .fit)
            
            HStack {
                Button("Previous") {
                    
                    if self.currentIndex >= self.photos.count {
                        self.currentIndex = self.currentIndex - 1
                    } else {
                        self.currentIndex = 0
                    }
                    
                    self.currentImage = UIImage(named: self.photos[self.currentIndex])!
                    
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .frame(width: 100)
                
                Button("Next") {
                    if self.currentIndex < self.photos.count - 1 {
                        self.currentIndex = self.currentIndex + 1
                    } else {
                        self.currentIndex = 0
                    }
                    
                    self.currentImage = UIImage(named: self.photos[self.currentIndex])!
                }
                .padding()
                .foregroundColor(Color.white)
                .frame(width: 100)
                .background(Color.gray)
                .cornerRadius(10)
            
                
                
            }.padding()
            
            Button("Classify") {
                
                // classify the image here
                self.detectFacialLandmarks { observations in
                    if let observations = observations {
                        // draw facial features
                        if let result = self.currentImage.drawLandmarksOnImage(observations: observations) {
                            self.currentImage = result
                        }
                    }
                }
                
            }.padding()
            .foregroundColor(Color.white)
            .background(Color.green)
            .cornerRadius(8)
            
            Text("")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
