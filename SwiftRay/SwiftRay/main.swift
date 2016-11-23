//
//  main.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 22/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

print("SwiftRay")

let width = 320
let height = 240
let bitmap = Bitmap(width: 320, height: 240)
bitmap.generate { (x, y) -> PixelRGBU in
    PixelRGBU(r: Float(x)/Float(width), g: Float(y)/Float(height), b: 0.0)
}

let path = "~/Desktop/Image.png"
let url = URL(fileURLWithPath: NSString(string: path).expandingTildeInPath)
if bitmap.writePng(url: url) {
    print("Image saved as \(path).")
} else {
    print("Error saving image at \(path).")
}


