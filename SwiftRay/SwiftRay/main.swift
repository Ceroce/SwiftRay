//
//  main.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 22/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

print("SwiftRay")

let Width = 200
let Height = 100
let Samples = 100

func backgroundColor(ray: Ray) -> Vec3 {
    let unitDir = normalize(ray.direction)
    let t = 0.5 * (unitDir.y + 1.0)
    let white = Vec3(1.0, 1.0, 1.0)
    let blue = Vec3(0.5, 0.7, 1.0)
    return mix(white, blue, t)
}

func color(ray: Ray, world: [Hitable]) -> Vec3 {
    let intersection = closestHit(ray: ray, hitables: world)
    if intersection != nil {
        return 0.5 * (intersection!.normal + Vec3(1.0))
    } else {
        return backgroundColor(ray: ray)
    }
}

func random01() -> Float {
    return Float(arc4random())/Float(UInt32.max)
}


let bitmap = Bitmap(width: Width, height: Height)
let camera = Camera()
let world: [Hitable] = [Sphere(center: Vec3(0.0, 0.0, -1.0), radius: 0.5),
                        Sphere(center: Vec3(0.0, -100.5, -1.0), radius: 100.0)]

bitmap.generate { (x, y) -> PixelRGBU in
    var colorSum = Vec3(0.0)
    for sample in 0..<Samples {
        let u = (Float(x)+random01()) / Float(Width)
        let v = 1.0 - (Float(y)+random01()) / Float(Height)
        let ray = camera.ray(u: u, v: v)
        let col = color(ray: ray, world: world)
        
        colorSum = colorSum + col
    }
    
    let colorAvg = colorSum / Float(Samples)
    return PixelRGBU(r: colorAvg.x , g: colorAvg.y , b: colorAvg.z)
}

let path = "~/Desktop/Image.png"
let url = URL(fileURLWithPath: NSString(string: path).expandingTildeInPath)
if bitmap.writePng(url: url) {
    print("Image saved as \(path).")
} else {
    print("Error saving image at \(path).")
}


