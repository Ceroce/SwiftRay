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
let DepthMax = 50

func random01() -> Float {
    return Float(arc4random())/Float(UInt32.max)
}

func randomMinus1Plus1() -> Float {
    return 2.0 * random01() - 1.0
}

func randomPointInsideUnitSphere() -> Vec3 {
    let radius = random01()
    return radius * normalize(Vec3(randomMinus1Plus1(), randomMinus1Plus1(), randomMinus1Plus1()))
}

func toneMap(color: Vec3) -> Vec3 {
    let gamma: Float = 2.0
    let invGamma = 1.0/gamma
    return Vec3(powf(color.x, invGamma), powf(color.y, invGamma), powf(color.z, invGamma))
}

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

let bitmap = Bitmap(width: Width, height: Height)
let camera = Camera(lookFrom: Vec3(-2, 2, 1), lookAt: Vec3(0, 0, -1), up: Vec3(0, 1, 0), yFov: 30, aspectRatio: Float(Width)/Float(Height))
let world: [Hitable] =
    [Sphere(center: Vec3(0.0, 0.0, -1.0), radius: 0.5, material: Lambertian(albedo: Vec3(0.1, 0.2, 0.5))),
     Sphere(center: Vec3(0.0, -100.5, -1.0), radius: 100.0, material: Lambertian(albedo: Vec3(0.8, 0.8, 0.0))),
     Sphere(center: Vec3(1.0, 0.0, -1.0), radius: 0.5, material: Metal(albedo: Vec3(0.8, 0.6, 0.2), fuzz: 0.0)),
     Sphere(center: Vec3(-1.0, 0.0, -1.0), radius: 0.5, material: Dielectric(refractionIndex: 1.5))
]

let startDate = Date()
bitmap.generate { (x, y) -> PixelRGBU in
    var colorSum = Vec3(0.0)
    for sample in 0..<Samples {
        let u = (Float(x)+random01()) / Float(Width)
        let v = 1.0 - (Float(y)+random01()) / Float(Height)
        let ray = camera.ray(u: u, v: v)
        let col = color(ray: ray, world: world, depth: 0)
        
        colorSum = colorSum + col
    }
    
    let colorAvg = colorSum / Float(Samples)
    let finalColor = toneMap(color: colorAvg)
    return PixelRGBU(r: finalColor.x , g: finalColor.y , b: finalColor.z)
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


