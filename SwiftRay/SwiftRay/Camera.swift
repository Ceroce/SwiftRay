//
//  Camera.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Darwin // Maths

struct Camera {
    let lookFrom: Vec3
    let lowerLeft: Vec3
    let horizontal: Vec3
    let vertical: Vec3
    
    let u: Vec3
    let v: Vec3
    
    let aperture: Float
    let startTime: Float
    let endTime: Float
    
    // yFov in degres. aspectRatio = width/height
    init(lookFrom: Vec3, lookAt: Vec3, up: Vec3, yFov: Float, aspectRatio: Float, aperture: Float, focusDistance: Float, startTime: Float, endTime: Float) {
        self.lookFrom = lookFrom
        self.aperture = aperture
        
        let theta = rad(yFov)
        let halfHeight = tanf(theta/2)
        let halfWidth = aspectRatio * halfHeight
        
        let w = normalize(lookFrom - lookAt) // Direction of the camera
        u = normalize(cross(up, w))
        v = cross(w, u)
        lowerLeft = lookFrom - halfWidth*focusDistance*u - halfHeight*focusDistance*v - focusDistance*w
        horizontal = 2 * halfWidth * focusDistance * u
        vertical = 2 * halfHeight * focusDistance * v
        
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func ray(s: Float, t: Float) -> Ray {
        // Depth of field is simulated by offsetting the origin of the ray randomly
        let defocus = (aperture/2.0) * randPointOnUnitDisc()
        let offset: Vec3 = u * defocus.x + v * defocus.y
        let time = self.startTime + random01()*(endTime-startTime)
        return Ray(origin: lookFrom+offset, direction: lowerLeft + s*horizontal + t*vertical - lookFrom - offset, time: time)
    }
    
    // Uses a rejection method
    func randPointOnUnitDisc() -> Vec3 {
        var p: Vec3
        repeat {
            p = 2 * Vec3(random01(), random01(), 0) - Vec3(1, 1, 0)
        } while dot(p, p) >= 1.0
        return p
    }
    
    
}
