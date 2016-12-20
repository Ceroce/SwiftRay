//
//  Image.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 22/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation
import CoreGraphics

struct PixelRGBU8 {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let u: UInt8 // Unused byte, for 32-bit alignment
    
    init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
        self.u = 0
    }
    
    init(r: Float, g: Float, b: Float) {
        let corrR = max(0.0, min(r, 1.0))
        let corrG = max(0.0, min(g, 1.0))
        let corrB = max(0.0, min(b, 1.0))
        self.init(r: UInt8(corrR*255.0), g: UInt8(corrG*255.0), b: UInt8(corrB*255.0))
    }
}

class Bitmap {
    let width : Int
    let height : Int
    let bitmapContext: CGContext
    let pixels : UnsafeMutableRawPointer
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        let bytesPerRow = width * MemoryLayout<PixelRGBU8>.size
        let size = height * bytesPerRow
        pixels = malloc(size)
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
        bitmapContext = CGContext(data: pixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    }
    
    deinit {
        free(pixels)
    }
    
    // The closure is given the x and y coordinates in the bitmap;
    // 0, 0 is in the top left corner.
    func generate(closure: (Int, Int) -> PixelRGBU8 ) {
        var pixelIndex = 0
        for y in 0..<height {
            for x in 0..<width {
                let offset = pixelIndex * MemoryLayout<PixelRGBU8>.size
                let pixel = closure(x, y)
                pixels.storeBytes(of: pixel, toByteOffset: offset, as: PixelRGBU8.self)
                pixelIndex += 1
            }
        }
    }
    
    func writePng(url: URL) -> Bool {
        let cgImage = bitmapContext.makeImage()
        guard cgImage != nil else {
            return false
        }
        
        let dest = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil)
        guard dest != nil else {
            return false
        }
        
        CGImageDestinationAddImage(dest!, cgImage!, nil)
        return CGImageDestinationFinalize(dest!)
    }
}
