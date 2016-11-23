//
//  Sphere.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Darwin // For maths

struct Sphere: Hitable {
    let center: Vec3
    let radius: Float
    
    /* Determining where a ray hits a sphere is solving a second order equation:
     t^2.dot(B,B) + 2t.dot(B, A-C) + dot(A-C, A-C) - R^2 = 0 */
    func hit(ray: Ray, distMin: Float, distMax: Float) -> HitIntersection? {
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
            return HitIntersection(distance: rootClose, position: hitPoint, normal: (hitPoint-center)/radius)
        } else {
            // It's to solve the case when the camera is inside the sphere, I guess 
            let rootFar = (-b + sqrDet) / a
            if (distMin < rootFar) && (rootClose < rootFar) {
                let hitPoint = ray.pointAt(distance: rootFar)
                return HitIntersection(distance: rootFar, position: hitPoint, normal: (hitPoint-center)/radius)
            } else {
                return nil
            }
        }
    }
}
