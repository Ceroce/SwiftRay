//
//  Lambertian.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

struct Lambertian : Material {
    let albedo : Texture
    
    // Right now, I don't see why the original ray is passed
    func scatteredRay(ray: Ray, intersection: HitIntersection) -> (Ray, Vec3)? {
        let target = intersection.position + intersection.normal + randomPointInsideUnitSphere()
        return (Ray(origin: intersection.position, direction: target-intersection.position, time: ray.time), albedo.value(u: 0, v: 0, point: intersection.position))
    }
    
}
