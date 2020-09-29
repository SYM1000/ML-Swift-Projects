//
//  UIImage+Extensions.swift
//  facial-landmarks
//
//

import Foundation
import UIKit
import Vision

extension UIImage {
    
    func drawLandmarksOnImage(observations: [VNFaceObservation]) -> UIImage? {
        
        UIGraphicsBeginImageContext(self.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("Unable to initialize context!")
        }
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        observations.forEach{ face in
            
            guard let landmark = face.landmarks else{
                return
            }
            
            let width = face.boundingBox.width * self.size.width
            let height = face.boundingBox.height * self.size.height
            let x = face.boundingBox.origin.x * self.size.width
            let y = face.boundingBox.origin.y * self.size.height
            
            let faceRect = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
            
            context.setStrokeColor(UIColor.red.cgColor)
            context.stroke(faceRect, width: 4.0)
            
            if let leftEye = landmark.leftEye{
                drawLines(context: context, points: leftEye.normalizedPoints, boundingBox: face.boundingBox)
            }
            
            if let rightEye = landmark.rightEye{
                drawLines(context: context, points: rightEye.normalizedPoints, boundingBox: face.boundingBox)
            }
            
            if let innerLips = landmark.innerLips{
                drawLines(context: context, points: innerLips.normalizedPoints, boundingBox: face.boundingBox)
            }
            if let outerLips = landmark.outerLips{
                drawLines(context: context, points: outerLips.normalizedPoints, boundingBox: face.boundingBox)
            }
            if let leftPupil = landmark.leftPupil {
                drawLines(context: context, points: leftPupil.normalizedPoints, boundingBox: face.boundingBox)
            }
            if let rightPupil = landmark.rightPupil {
                drawLines(context: context, points: rightPupil.normalizedPoints, boundingBox: face.boundingBox)
            }
            
            

            
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
                
        return result
    }
    
    private func drawLines(context: CGContext, points: [CGPoint], boundingBox: CGRect ){
        
        let width = boundingBox.width * self.size.width
        let height = boundingBox.height * self.size.height
        let x = boundingBox.origin.x * self.size.width
        let y = boundingBox.origin.y * self.size.height
        
        context.setStrokeColor(UIColor.yellow.cgColor)
        
        var lastPoint = CGPoint.zero
        
        points.forEach{currentPoint in
            if lastPoint == CGPoint.zero{
                context.move(to: CGPoint(x: currentPoint.x * width + x, y: currentPoint.y * height + y))
                lastPoint = currentPoint
            } else {
                context.addLine(to: CGPoint(x: currentPoint.x * width + x, y: currentPoint.y * height + y))
            }
        }
        context.closePath()
        context.setLineWidth(4)
        context.drawPath(using: .stroke)
    }
    
}
