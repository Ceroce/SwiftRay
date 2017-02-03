//
//  Rectangle.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 03/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//

// Rectangle aligned on the XY axis
struct XYRectangle: Hitable {
    let x0: Float
    let x1: Float
    let y0: Float
    let y1: Float
    let k: Float
    let material: Material
    
    init(x0: Float, x1: Float, y0: Float, y1: Float, k: Float, material: Material) {
        self.x0 = x0
        self.x1 = x1
        self.y0 = y0
        self.y1 = y1
        self.k = k
        self.material = material
    }
    
    func hit(ray: Ray, distMin: Float, distMax: Float) -> HitIntersection? {
        // Find t (distance from the origin of the ray) when the ray hits the z coordinate
        let t = (k-ray.origin.z)/ray.direction.z
        if t < distMin || t > distMax {
            return nil
        }
        
        // Replace t in the equation of the ray, and see if x and y fit within the x0..x1 and y0..y1 ranges
        let hitPoint = ray.pointAt(distance: t)
        if hitPoint.x < x0 || hitPoint.x > x1 {
            return nil
        }
        if hitPoint.y < y0 || hitPoint.y > y1 {
            return nil
        }
        
        return HitIntersection(distance: t, position: hitPoint, normal: Vec3(0.0, 0.0, 1.0), material: material)
    }
    
    func boundingBox(startTime: Float, endTime: Float) -> BoundingBox {
        // It might be needed to give a thickness
        return BoundingBox(minPoint: Vec3(x0, y0, k), maxPoint: Vec3(x1, y1, k))
    }
}
