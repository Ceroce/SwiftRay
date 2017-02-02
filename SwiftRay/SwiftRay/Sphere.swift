//
//  Sphere.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Darwin // For maths

struct Sphere: Hitable {
    let startCenter: Vec3
    let endCenter: Vec3
    let startTime: Float
    let endTime: Float
    let radius: Float
    let material: Material
    
    init(startCenter: Vec3, endCenter: Vec3, startTime: Float, endTime: Float, radius: Float, material: Material) {
        self.startCenter = startCenter
        self.endCenter = endCenter
        self.startTime = startTime
        self.endTime = endTime
        self.radius = radius
        self.material = material
    }
    
    
    // Commodity initializer when the sphere does not move
    init(center: Vec3, radius: Float, material: Material) {
        self.startCenter = center
        self.endCenter = center
        self.startTime = 0.0
        self.endTime = 1.0
        self.radius = radius
        self.material = material
    }
    
    /* Determining where a ray hits a sphere is solving a second order equation:
     t^2.dot(B,B) + 2t.dot(B, A-C) + dot(A-C, A-C) - R^2 = 0 */
    func hit(ray: Ray, distMin: Float, distMax: Float) -> HitIntersection? {
        let center = centerAt(time: ray.time)
        let oc: Vec3 = ray.origin - center
        let a = dot(ray.direction, ray.direction)
        let b = dot(ray.direction, oc)
        let c = dot(oc, oc) - radius*radius
        let det = b*b - a*c
        let sqrDet = sqrtf(det)
        
        guard det >= 0.0 else {
            return nil
        }
        
        let rootClose = (-b - sqrDet) / a
        if (distMin < rootClose) && (rootClose < distMax) {
            let hitPoint = ray.pointAt(distance: rootClose)
            return HitIntersection(distance: rootClose, position: hitPoint, normal: (hitPoint-center)/radius, material: material)
        } else {
            // It's to solve the case when the camera is inside the sphere, I guess 
            let rootFar = (-b + sqrDet) / a
            if (distMin < rootFar) && (rootClose < rootFar) {
                let hitPoint = ray.pointAt(distance: rootFar)
                return HitIntersection(distance: rootFar, position: hitPoint, normal: (hitPoint-center)/radius, material: material)
            } else {
                return nil
            }
        }
    }
    
    func boundingBox(startTime: Float, endTime: Float) -> BoundingBox? {
        let Size = Vec3(radius)
        let firstCenter = centerAt(time: startTime)
        let secondCenter = centerAt(time: endTime)
        return BoundingBox(minPoint: min(firstCenter-Size, secondCenter-Size), maxPoint: max(firstCenter+Size, secondCenter+Size))
    }
    
    private func centerAt(time: Float) -> Vec3 {
        return startCenter + ((time-startTime)/(endTime-startTime))*(endCenter-startCenter)
    }
}
