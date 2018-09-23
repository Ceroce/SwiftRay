//
//  main.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 22/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

// Size of the generated image
let Width = 400
let Height = 266

// The number of rounds of rendering.
// Each round generates a Sample (= an image with float components), which is accumulated to the previous samples using a weighted average. The more samples, the less noisy is the final image. Of course, rendering time is linear with the number of samples.
let Samples = 100

// Maximum number of scattered rays.
// When a ray hits an object, a scattered ray is emitted in the direction symetric to the incoming ray, relative to the normal of the object at the point hit, and so on, until no object is hit (= the ray "falls" into the sky). This may potentially never end, so we set a maximum count of scattered rays. In practice, this does not have much impact neither on the rendering time nor the quality, so you should keep the defaut value.
let DepthMax = 50


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

// Scenes are currently described using structs conforming to the Scene protocol.
// Since this is Swift code, the inconvenient is that Scene must be added to the project and compiled.
// We could define an other format (e.g. based on JSON), but then it would need be parsed, and we would not have Xcode's autocompletion to help us!
let scene = BigAndSmallSpheresScene(aspectRatio: Float(Width)/Float(Height))

print("SwiftRay")

// The final image is saved on the Desktop. This is OK on the Mac.
let imagePath = "~/Desktop/Image.png"
let url = URL(fileURLWithPath: NSString(string: imagePath).expandingTildeInPath)
print("Generating image (\(Width) by \(Height)) at \(imagePath)")
let startDate = Date()

let bitmap = Bitmap(width: Width, height: Height)
let accumulator = ImageAccumulator()

// This save() function takes a sample, accumulates it to the previous samples, applies tone mapping then saves it as PNG.
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

// To take best advantage of multiple cores, one sample ought to be rendered on each core.
let raytracingQueue = OperationQueue()
raytracingQueue.name = "com.ceroce.SwiftRay Raytracing"
raytracingQueue.maxConcurrentOperationCount = 4 // Parallel queue. Set this to the number of cores of your Mac.

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

// Wait for all operations to finish
while samplesRendered == 0 || (raytracingQueue.operationCount > 0) || (imageSavingQueue.operationCount > 0) {
}

let renderingDuration = Date().timeIntervalSince(startDate)
print("Image rendered in \(renderingDuration) s.")




