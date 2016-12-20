//
//  Image.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 20/12/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

struct PixelRGB32 {
    let r: Float32
    let g: Float32
    let b: Float32
}

// An image with 32-bit float components
class Image {
    let width: Int
    let height: Int
    let pixels: UnsafeMutableRawPointer
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        let bytesPerRow = width * MemoryLayout<PixelRGB32>.size
        let size = height * bytesPerRow;
        pixels = malloc(size)
    }
    
    // The closure is given the x and y coordinates in the bitmap;
    // 0, 0 is in the top left corner.
    func generate(closure: (Int, Int) -> PixelRGB32 ) {
        var pixelIndex = 0
        for y in 0..<height {
            for x in 0..<width {
                let offset = pixelIndex * MemoryLayout<PixelRGB32>.size
                let pixel = closure(x, y)
                pixels.storeBytes(of: pixel, toByteOffset: offset, as: PixelRGB32.self)
                pixelIndex += 1
            }
        }
    }
    
    func pixelAt(x: Int, y:Int) -> PixelRGB32 {
        let pixelIndex = y * self.width + x
        let offset = pixelIndex * MemoryLayout<PixelRGB32>.size
        return pixels.load(fromByteOffset: offset, as: PixelRGB32.self)
    }
    
    deinit {
        free(pixels)
    }
    
}
