//
//  YZRectangle.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 03/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//

// Rectangle aligned on the YZ axis
struct YZRectangle: Hitable {
    let y0: Float
    let y1: Float
    let z0: Float
    let z1: Float
    let k: Float
    let material: Material
    
    init(y0: Float, y1: Float, z0: Float, z1: Float, k: Float, material: Material) {
        self.y0 = y0
        self.y1 = y1
        self.z0 = z0
        self.z1 = z1
        self.k = k
        self.material = material
    }
    
    func hit(ray: Ray, distMin: Float, distMax: Float) -> HitIntersection? {
        // Find t (distance from the origin of the ray) when the ray hits the x coordinate
        let t = (k-ray.origin.x)/ray.direction.x
        if t < distMin || t > distMax {
            return nil
        }
        
        // Replace t in the equation of the ray, and see if y and z fit within the y0..y1 and z0..z1 ranges
        let hitPoint = ray.pointAt(distance: t)
        if hitPoint.y < y0 || hitPoint.y > y1 {
            return nil
        }
        if hitPoint.z < z0 || hitPoint.z > z1 {
            return nil
        }
        
        return HitIntersection(distance: t, position: hitPoint, normal: Vec3(1.0, 0.0, 0.0), material: material)
    }
    
    func boundingBox(startTime: Float, endTime: Float) -> BoundingBox {
        // It might be needed to give a thickness
        return BoundingBox(minPoint: Vec3(k, y0, z0), maxPoint: Vec3(k, y1, z1))
    }
}
