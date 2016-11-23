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

func backgroundColor(ray: Ray) -> Vec3 {
    let unitDir = normalize(ray.direction)
    let t = 0.5 * (unitDir.y + 1.0)
    let white = Vec3(1.0, 1.0, 1.0)
    let blue = Vec3(0.5, 0.7, 1.0)
    return mix(white, blue, t)
}

func color(ray: Ray) -> Vec3 {
    let sphereCenter = Vec3(0.0, 0.0, -1.0)
    let t = distanceOfSphereHitByRay(center: sphereCenter, radius: 0.5, ray: ray)
    if t > 0.0  {
        let normal = normalize(ray.pointAt(distance: t) - sphereCenter)
        return 0.5 * (normal + Vec3(1.0))
    } else {
        return backgroundColor(ray: ray)
    }
}

/* Determining where a ray hits a sphere is solving a second order equation:
   t^2.dot(B,B) + 2t.dot(B, A-C) + dot(A-C, A-C) - R^2 = 0 */
func distanceOfSphereHitByRay(center: Vec3, radius: Float, ray: Ray) -> Float {
    let oc: Vec3 = ray.origin - center
    let a = dot(ray.direction, ray.direction)
    let b = 2.0 * dot(ray.direction, oc)
    let c = dot(oc, oc) - radius*radius
    let det = b*b - 4.0*a*c
    
    if det < 0 {
        return -1.0
    } else {
        return (-b - sqrtf(det)) / (2.0 * a)
    }
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
    let col = color(ray: ray)
    return PixelRGBU(r: col.x , g: col.y , b: col.z)
}

let path = "~/Desktop/Image.png"
let url = URL(fileURLWithPath: NSString(string: path).expandingTildeInPath)
if bitmap.writePng(url: url) {
    print("Image saved as \(path).")
} else {
    print("Error saving image at \(path).")
}


