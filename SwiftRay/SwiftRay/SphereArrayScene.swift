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
        self.camera = Camera(lookFrom: Vec3(15, 5, 12), lookAt: Vec3(0, 0, 0), up: Vec3(0, 1, 0), yFov: 20, aspectRatio: aspectRatio, aperture: 0.1, focusDistance: 10.0, startTime: startTime, endTime: endTime)
        
        var spheres: [Hitable] = []
        
        let mini = -1
        let maxi = 1
        
        for z in mini...maxi {
            for y in mini...maxi {
                for x in mini...maxi {
                    let center = Vec3(Float(x), Float(y), Float(z))
                    spheres.append(Sphere(center: center, radius: 0.2, material: Lambertian(albedo: Vec3(random01(), random01(), random01()) )))
                }
            }
        }
        
//        hitables = spheres
        let immutSpheres = spheres
        hitables = [BoundingNode(hitables: immutSpheres, startTime: startTime, endTime: endTime)]
    }
}
