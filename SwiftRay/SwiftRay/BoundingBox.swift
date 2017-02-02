//
//  BoundingBox.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 01/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//

// Axis-Aligned Bounding Box of a Hitable
struct BoundingBox {
    let minPoint: Vec3
    let maxPoint: Vec3
    
    func isHitBy(ray: Ray, distMin: Float, distMax: Float) -> Bool {
        for component in 0..<3 {
            let invD = Float(1.0) / ray.direction[component]
            let t0 = (minPoint[component] - ray.origin[component]) * invD
            let t1 = (maxPoint[component] - ray.origin[component]) * invD
            
            var tMin = min(t0, t1)
            if(tMin < distMin) {
                tMin = distMin
            }
            
            var tMax = max(t0, t1)
            if tMax > distMax {
                tMax = distMax
            }
                
            if tMax <= tMin {
                return false
            }
        }
        
        return true
    }

    static func surroundingBox(box0: BoundingBox, box1: BoundingBox) -> BoundingBox {
        return BoundingBox(minPoint: min(box0.minPoint, box1.minPoint), maxPoint: max(box0.maxPoint, box1.maxPoint))
    }
}
