//
//  UIImage+Extensions.swift
//  highlight-faces
//
//

import Foundation
import Vision
import UIKit

extension UIImage {
    
    
    func drawOnImage(observations: [VNFaceObservation]) -> UIImage? {
        
        UIGraphicsBeginImageContext(self.size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        self.draw(in: CGRect(x: 0, y:0, width: self.size.width, height: self.size.height))
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(5.0)
        
        let transform = CGAffineTransform(scaleX: 1, y: -1)
            .translatedBy(x: 0, y: -self.size.height)
        
        for observation in observations {
            
            let rect = observation.boundingBox
            let normalizedRect = VNImageRectForNormalizedRect(rect, Int(self.size.width), Int(self.size.height))
                .applying(transform)
            context.stroke(normalizedRect)
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
        
    }
    
}
