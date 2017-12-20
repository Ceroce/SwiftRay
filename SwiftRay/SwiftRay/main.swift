//
//  main.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 22/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

let Width = 400     // Width of the generated image
let Height = 266    // Height of the generated image
let Samples = 500   // Number of rays for each pixel
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

func toneMap(color: PixelRGB32) -> PixelRGBU8 {
    let gamma: Float = 2.0
    let invGamma = 1.0/gamma
    return PixelRGBU8(r: powf(color.r, invGamma), g: powf(color.g, invGamma), b: powf(color.b, invGamma))
}

// *** Main ***

let scene = BigAndSmallSpheresScene(aspectRatio: Float(Width)/Float(Height))

print("SwiftRay")
let imagePath = "~/Desktop/Image.png"
let url = URL(fileURLWithPath: NSString(string: imagePath).expandingTildeInPath)
print("Generating image (\(Width) by \(Height)) at \(imagePath)")
let startDate = Date()

let bitmap = Bitmap(width: Width, height: Height)
let accumulator = ImageAccumulator()

func save(image: Image) {
    let accumulatedImage =  accumulator.accumulate(image: image)
    bitmap.generate { (x, y) -> PixelRGBU8 in
        return toneMap(color: accumulatedImage.pixelAt(x: x, y: y))
    }
    
    if !bitmap.writePng(url: url) {
        print("Error saving image at \(imagePath).")
    }
}
func printProgress(sampleIndex: Int, sampleCount:Int) {
    let progress = (Float(sampleIndex+1)/Float(sampleCount))*100.0
    print("Sample \(sampleIndex+1)/\(sampleCount) (\(progress) %)")
}


let raytracingQueue = OperationQueue()
raytracingQueue.name = "com.ceroce.SwiftRay Raytracing"
raytracingQueue.maxConcurrentOperationCount = 4 // Parallel queue

let imageSavingQueue = OperationQueue()
imageSavingQueue.name = "com.ceroce.SwiftRay Image Saving"
imageSavingQueue.maxConcurrentOperationCount = 1    // Serial queue


var samplesRendered = 0;
for _ in 0..<Samples {
    raytracingQueue.addOperation {
        let image = Image(width: Width, height: Height)
        image.generate { (x, y) -> PixelRGB32 in
            let s = (Float(x)+random01()) / Float(Width)
            let t = 1.0 - (Float(y)+random01()) / Float(Height)
            let ray = scene.camera.ray(s: s, t: t)
            let col = color(ray: ray, world: scene.hitables, depth: 0)
            
            return PixelRGB32(r: col.x, g: col.y, b: col.z)
        }
        
        imageSavingQueue.addOperation {
            save(image: image)
            printProgress(sampleIndex: samplesRendered, sampleCount: Samples)
            samplesRendered += 1
        }
    }
}

while samplesRendered == 0 || (raytracingQueue.operationCount > 0) || (imageSavingQueue.operationCount > 0) {
    // Wait
}

let renderingDuration = Date().timeIntervalSince(startDate)
print("Image rendered in \(renderingDuration) s.")




