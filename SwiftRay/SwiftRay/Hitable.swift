//
//  Hitable.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

struct HitIntersection {
    let distance: Float // Distance from the origin of the ray
    let position: Vec3
    let normal: Vec3
}

protocol Hitable {
    func hit(ray: Ray, distMin: Float, distMax: Float) -> HitIntersection?
}

func closestHit(ray: Ray, hitables: [Hitable]) -> HitIntersection? {
    var closerIntersection: HitIntersection? = nil
    var closestSoFar: Float = Float.infinity
    for hitable in hitables {
        if let intersection = hitable.hit(ray: ray, distMin: 0.001, distMax: closestSoFar) {
            if intersection.distance < closestSoFar {
                closestSoFar = intersection.distance
                closerIntersection = intersection
            }
        }
    }
    
    return closerIntersection
}
