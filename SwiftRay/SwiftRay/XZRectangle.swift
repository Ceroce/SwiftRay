//
//  XZRectangle.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 03/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//

// Rectangle aligned on the XZ axis
struct XZRectangle: Hitable {
    let x0: Float
    let x1: Float
    let z0: Float
    let z1: Float
    let k: Float
    let material: Material
    
    init(x0: Float, x1: Float, z0: Float, z1: Float, k: Float, material: Material) {
        self.x0 = x0
        self.x1 = x1
        self.z0 = z0
        self.z1 = z1
        self.k = k
        self.material = material
    }
    
    func hit(ray: Ray, distMin: Float, distMax: Float) -> HitIntersection? {
        // Find t (distance from the origin of the ray) when the ray hits the y coordinate
        let t = (k-ray.origin.y)/ray.direction.y
        if t < distMin || t > distMax {
            return nil
        }
        
        // Replace t in the equation of the ray, and see if x and z fit within the x0..x1 and z0..z1 ranges
        let hitPoint = ray.pointAt(distance: t)
        if hitPoint.x < x0 || hitPoint.x > x1 {
            return nil
        }
        if hitPoint.z < z0 || hitPoint.z > z1 {
            return nil
        }
        
        return HitIntersection(distance: t, position: hitPoint, normal: Vec3(0.0, 1.0, 0.0), material: material)
    }
    
    func boundingBox(startTime: Float, endTime: Float) -> BoundingBox {
        // It might be needed to give a thickness
        return BoundingBox(minPoint: Vec3(x0, k, z0), maxPoint: Vec3(x1, k, z1))
    }
}
