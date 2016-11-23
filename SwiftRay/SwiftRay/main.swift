//
//  main.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 22/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

print("SwiftRay")

let width = 200
let height = 100

func color(ray: Ray) -> Vec3 {
    let unitDir = normalize(ray.direction)
    let t = 0.5 * (unitDir.y + 1.0)
    let white = Vec3(1.0, 1.0, 1.0)
    let blue = Vec3(0.5, 0.7, 1.0)
    return mix(white, blue, t)
}

let bitmap = Bitmap(width: width, height: height)
let lowerLeft = Vec3(-2.0, -1.0, -1.0)
let horizontal = Vec3(4.0, 0.0, 0.0)
let vertical = Vec3(0.0, 2.0, 0.0)
let origin = Vec3(0.0, 0.0, 0.0)

bitmap.generate { (x, y) -> PixelRGBU in
    let u = Float(x)/Float(width)
    let v = 1.0 - Float(y)/Float(height)
    let ray = Ray(origin: origin, direction: lowerLeft + u*horizontal + v*vertical)
    let backgroundColor = color(ray: ray)
    return PixelRGBU(r: backgroundColor.x , g: backgroundColor.y , b: backgroundColor.z)
}

let path = "~/Desktop/Image.png"
let url = URL(fileURLWithPath: NSString(string: path).expandingTildeInPath)
if bitmap.writePng(url: url) {
    print("Image saved as \(path).")
} else {
    print("Error saving image at \(path).")
}


