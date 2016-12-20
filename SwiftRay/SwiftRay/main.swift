//
//  main.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 22/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

print("SwiftRay")

let Width = 200     // Width of the generated image
let Height = 100    // Height of the generated image
let Samples = 10   // Number of rays for each pixel
let DepthMax = 50   // Maximum number of scattered rays




func backgroundColor(ray: Ray) -> Vec3 {
    let unitDir = normalize(ray.direction)
    let t = 0.5 * (unitDir.y + 1.0)
    let white = Vec3(1.0, 1.0, 1.0)
    let blue = Vec3(0.5, 0.7, 1.0)
    return mix(white, blue, t)
}

func color(ray: Ray, world: [Hitable], depth: Int) -> Vec3 {
    guard depth < DepthMax else {
        return backgroundColor(ray: ray)
    }
    
    guard let intersection = closestHit(ray: ray, hitables: world) else {
        return backgroundColor(ray: ray)
    }
    
    guard let (secondaryRay, attenuation) = intersection.material.scatteredRay(ray: ray, intersection: intersection) else {
        return backgroundColor(ray: ray)
    }

    return attenuation * color(ray: secondaryRay, world: world, depth: depth+1)
}

let image = Image(width: Width, height: Height)
let bitmap = Bitmap(width: Width, height: Height)


let scene = SimpleScene(aspectRatio: Float(Width)/Float(Height))

let startDate = Date()
image.generate { (x, y) -> PixelRGB32 in
    var colorSum = Vec3(0.0)
    for sample in 0..<Samples {
        let s = (Float(x)+random01()) / Float(Width)
        let t = 1.0 - (Float(y)+random01()) / Float(Height)
        let ray = scene.camera.ray(s: s, t: t)
        let col = color(ray: ray, world: scene.hitables, depth: 0)
        
        colorSum = colorSum + col
    }
    
    let colorAvg = colorSum / Float(Samples)
    return PixelRGB32(r: colorAvg.x, g: colorAvg.y, b: colorAvg.z)
}


func toneMap(color: PixelRGB32) -> PixelRGBU8 {
    let gamma: Float = 2.0
    let invGamma = 1.0/gamma
    return PixelRGBU8(r: powf(color.r, invGamma), g: powf(color.g, invGamma), b: powf(color.b, invGamma))
}

bitmap.generate { (x, y) -> PixelRGBU8 in
    return toneMap(color: image.pixelAt(x: x, y: y))
}


let renderingDuration = Date().timeIntervalSince(startDate)
print("Image rendered in \(renderingDuration) s.")


let path = "~/Desktop/Image.png"
let url = URL(fileURLWithPath: NSString(string: path).expandingTildeInPath)
if bitmap.writePng(url: url) {
    print("Image saved as \(path).")
} else {
    print("Error saving image at \(path).")
}


