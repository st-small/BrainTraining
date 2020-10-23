//
//  DrawingImageView.swift
//  BrainTraining
//
//  Created by Stanly Shiyanovskiy on 23.10.2020.
//

import UIKit

public final class DrawingImageView: UIImageView {

    // MARK: - Data
    public weak var delegate: ViewController?
    private var currentTouchPosition: CGPoint?
    
    private func draw(from start: CGPoint, to end: CGPoint) {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)

        image = renderer.image { ctx in
            image?.draw(in: bounds)

            UIColor.black.setStroke()
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setLineWidth(15)

            ctx.cgContext.move(to: start)
            ctx.cgContext.addLine(to: end)
            ctx.cgContext.strokePath()
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        currentTouchPosition = touches.first?.location(in: self)

        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let newTouchPoint = touches.first?.location(in: self) else { return }
        guard let previousTouchPoint = currentTouchPosition else { return }

        draw(from: previousTouchPoint, to: newTouchPoint)
        currentTouchPosition = newTouchPoint
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        currentTouchPosition = nil

        perform(#selector(numberDrawn), with: nil, afterDelay: 0.3)
    }

    @objc
    private func numberDrawn() {
        guard let image = image else { return }

        let drawRect = CGRect(x: 0, y: 0, width: 28, height: 28)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(bounds: drawRect, format: format)

        let imageWithBackground = renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(bounds)
            image.draw(in: drawRect)
        }

        let ciImage = CIImage(cgImage: imageWithBackground.cgImage!)

        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setDefaults()
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            let context = CIContext(options: nil)

            if let outputImage = filter.outputImage {
                if let imageRef = context.createCGImage(outputImage, from: ciImage.extent) {
                    let finalImage = UIImage(cgImage: imageRef)
                    delegate?.numberDrawn(finalImage)
                }
            }
        }
    }
}
