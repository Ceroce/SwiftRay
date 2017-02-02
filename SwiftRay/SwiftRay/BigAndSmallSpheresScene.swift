//
//  BigAndSmallSpheresScene.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 19/12/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

struct BigAndSmallSpheresScene: Scene {
    let camera: Camera
    let hitables: [Hitable]
    
    init(aspectRatio: Float) {
        let startTime: Float = 0.0
        let endTime: Float = 1.0
        self.camera = Camera(lookFrom: Vec3(13, 2, 3), lookAt: Vec3(0, 0, 0), up: Vec3(0, 1, 0), yFov: 20, aspectRatio: aspectRatio, aperture: 0.1, focusDistance: 10.0, startTime: startTime, endTime: endTime)
        
        var spheres: [Hitable] = []
        
        // Ground
        let ground = Sphere(center: Vec3(0, -1000, 0), radius: 1000, material: Lambertian(albedo: Vec3(0.5)))
        spheres.append(ground)
        
        // A number of small spheres
        for z in -11...11 {
            for x in -11...11 {
                let radius: Float = 0.2
                let startCenter = Vec3(Float(x) + 0.9*random01(), radius, Float(z) + 0.9*random01())
                let endCenter = startCenter// + Vec3(0.0, random01()*0.5, 0.0)
                
                let chooseMat = random01()
                var material: Material
                if chooseMat < 0.8 {
                    material = Lambertian(albedo: Vec3(random01(), random01(), random01()))
                } else if chooseMat < 0.95 {
                    material = Metal(albedo: 0.5*Vec3(1.0+random01(), 1.0+random01(), 1.0+random01()), fuzz: 0.5*random01())
                } else {
                    material = Dielectric(refractionIndex: RefractionIndex.Glass.rawValue)
                }
                
                spheres.append(Sphere(startCenter: startCenter, endCenter: endCenter, startTime: startTime, endTime: endTime, radius: radius, material: material))
            }
        }
        
        // 3 big spheres
        spheres.append(Sphere(center: Vec3(0, 1, 0), radius: 1.0, material: Dielectric(refractionIndex: RefractionIndex.Cristal.rawValue)))
        spheres.append(Sphere(center: Vec3(-4, 1, 0), radius: 1.0, material: Lambertian(albedo: Vec3(0.4, 0.2, 0.1))))
        spheres.append(Sphere(center: Vec3(4, 1, 0), radius: 1.0, material: Metal(albedo: Vec3(0.7, 0.6, 0.5), fuzz: 0.0)))
        
//        hitables = spheres
        let boundingVolumeHierarchy = BoundingNode(hitables: spheres, startTime: startTime, endTime: endTime)
        hitables = [boundingVolumeHierarchy]
    }
}
