//
//  SphereArrayScene.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 02/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//

struct SphereArrayScene {
    let camera: Camera
    let hitables: [Hitable]
    
    init(aspectRatio: Float) {
        let startTime: Float = 0.0
        let endTime: Float = 1.0
        self.camera = Camera(lookFrom: Vec3(15, 5, 12), lookAt: Vec3(0, 0, 0), up: Vec3(0, 1, 0), yFov: 20, aspectRatio: aspectRatio, aperture: 0.1, focusDistance: length(Vec3(15, 5, 12)), startTime: startTime, endTime: endTime)
        
        var mutHitables: [Hitable] = []
        
        let mini = -2
        let maxi = 2
        
        for z in mini...maxi {
            for y in mini...maxi {
                for x in mini...maxi {
                    let center = Vec3(Float(x), Float(y), Float(z))
                    mutHitables.append(Sphere(center: center, radius: 0.2, material: Lambertian(albedo: ConstantTexture(color: Vec3(random01(), random01(), random01())) )))
                }
            }
        }
        
        let bvh = BoundingVolumeHierarchy(hitables: mutHitables, startTime: startTime, endTime: endTime)
        let bounds = bvh.boundingBox(startTime: startTime, endTime: endTime)
        
        let redRect = XZRectangle(x0: bounds.minPoint.x, x1: bounds.maxPoint.x, z0: bounds.minPoint.z, z1: bounds.maxPoint.z, k: bounds.minPoint.y, material: Lambertian(albedo: ConstantTexture(color: Vec3(1, 0, 0))))
        
        let blueRect = XYRectangle(x0: bounds.minPoint.x, x1: bounds.maxPoint.x, y0: bounds.minPoint.y, y1: bounds.maxPoint.y, k: bounds.minPoint.z, material: Lambertian(albedo: ConstantTexture(color: Vec3(0, 0, 1))))
        
        mutHitables.append(redRect)
        mutHitables.append(blueRect)
        let bvh2 = BoundingVolumeHierarchy(hitables: mutHitables, startTime: startTime, endTime: endTime)
        hitables = [bvh2]
    }
}
