//
//  Metal.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

struct Metal : Material {
    let albedo: Texture
    let fuzz: Float
    
    func scatteredRay(ray: Ray, intersection: HitIntersection) -> (Ray, Vec3)? {
        let reflected = reflect(v: normalize(ray.direction), normal: intersection.normal) + randomPointInsideUnitSphere()*fuzz
        if dot(reflected, intersection.normal) > 0.0 { // The ray is not tangent to the surface
            let scattered = Ray(origin: intersection.position, direction: reflected, time: ray.time)
            return (scattered, albedo.value(u: 0, v: 0, point: intersection.position))
        } else {
            return nil
        }
    }
    
    private func reflect(v: Vec3, normal: Vec3) -> Vec3 {
        return v - 2.0 * dot(v, normal) * normal
    }
}
