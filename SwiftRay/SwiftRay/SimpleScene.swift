//
//  SimpleScene.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 19/12/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

struct SimpleScene: Scene {
    let camera: Camera
    let hitables: [Hitable]
    
    init(aspectRatio: Float) {
        let lookFrom = Vec3(0, 0.5, 0.7)
        let lookAt = Vec3(0, 0, -1)
        camera = Camera(lookFrom: lookFrom, lookAt: lookAt, up: Vec3(0, 1, 0), yFov: 60, aspectRatio: aspectRatio, aperture: 0.1, focusDistance: length(lookAt-lookFrom), startTime: 0.0, endTime: 1.0)
        
        let spheres = [
            Sphere(center: Vec3(0, -100.5, -1), radius: 100, material: Lambertian(albedo: Vec3(0.8, 0.8, 0.0))), // Ground
            Sphere(center: Vec3(-1, 0, -1), radius: 0.5, material: Dielectric(refractionIndex: RefractionIndex.Cristal.rawValue)),
            Sphere(center: Vec3(0, 0, -1), radius: 0.5, material: Lambertian(albedo: Vec3(0.1, 0.2, 0.5))),
            Sphere(center: Vec3(1, 0, -1), radius: 0.5, material: Metal(albedo: Vec3(0.8, 0.6, 0.2), fuzz: 0.2))
        ]
        
        hitables =  [BoundingNode(hitables: spheres, startTime: 0.0, endTime: 1.0)]
    }
}
