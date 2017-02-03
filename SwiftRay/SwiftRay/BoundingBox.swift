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
    
    init(minPoint: Vec3, maxPoint: Vec3) {
        assert(minPoint.x <= maxPoint.x)
        assert(minPoint.y <= maxPoint.y)
        assert(minPoint.z <= maxPoint.z)
        self.minPoint = minPoint
        self.maxPoint = maxPoint
    }
    
    // The technique consists in finding t (the distance from the origin of the ray) when 
    // the ray touches edges of the bounding box — which are aligned with the axises.
    // We get two distances for each axis (tx0, tx1, ty0, ty1, tz0, tz1).
    // The ray hits the box only if all ranges [tx0..tx1], [ty0..ty1], [tz0..tz1] overlap.
    // The implementation has two markers: tmin for the lower t among the three axes, and tmax for the upper t.
    // If both markers cross, then there is not overlapping.
    func isHitBy(ray: Ray, distMin: Float, distMax: Float) -> Bool {
        var tmin = distMin
        var tmax = distMax
        
        for component in 0..<3 {
            let invD = Float(1.0) / ray.direction[component]
            let t0 = (minPoint[component] - ray.origin[component]) * invD
            let t1 = (maxPoint[component] - ray.origin[component]) * invD
            tmin = max(tmin, min(t0, t1))
            tmax = min(tmax, max(t0, t1))
    
            if tmax <= tmin { // Markers have crossed
                return false
            }
        }
        
        return true
    }

    static func surroundingBox(box0: BoundingBox, box1: BoundingBox) -> BoundingBox {
        return BoundingBox(minPoint: min(box0.minPoint, box1.minPoint),
                           maxPoint: max(box0.maxPoint, box1.maxPoint))
    }
}
