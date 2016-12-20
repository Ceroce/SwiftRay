//
//  ImageAccumulation.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 20/12/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

// Accumulates an image to previous images using a weighted average
class ImageAccumulator {
    var accumulatedImage: Image? = nil
    var accumulations: Int = 0
    
    func accumulate(image: Image) -> Image {
        if self.accumulatedImage != nil {
            self.accumulatedImage!.generate(closure: { (x, y) -> PixelRGB32 in
                let accuPixel = self.accumulatedImage!.pixelAt(x: x, y: y)
                let newPixel = image.pixelAt(x: x, y: y)
                // Weighted average
                return PixelRGB32(r: (Float(self.accumulations)*accuPixel.r + newPixel.r)/(Float(self.accumulations)+1.0),
                                  g: (Float(self.accumulations)*accuPixel.g + newPixel.g)/(Float(self.accumulations)+1.0),
                                  b: (Float(self.accumulations)*accuPixel.b + newPixel.b)/(Float(self.accumulations)+1.0))
            })
            accumulations += 1
            return self.accumulatedImage!
        } else {
            self.accumulatedImage = image
            accumulations = 1
            return self.accumulatedImage!
        }
    }
}
