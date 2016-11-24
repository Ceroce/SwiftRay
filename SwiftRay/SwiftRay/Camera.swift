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
    
    // yFov in degres. aspectRatio = width/height
    init(lookFrom: Vec3, lookAt: Vec3, up: Vec3, yFov: Float, aspectRatio: Float) {
        self.lookFrom = lookFrom
        
        let theta = rad(yFov)
        let halfHeight = tanf(theta/2)
        let halfWidth = aspectRatio * halfHeight
        
        let w = normalize(lookFrom - lookAt) // Direction of the camera
        let u = normalize(cross(up, w))
        let v = cross(w, u)
        lowerLeft = lookFrom - halfWidth*u - halfHeight*v - w
        horizontal = 2 * halfWidth * u
        vertical = 2 * halfHeight * v
    }
    
    func ray(u: Float, v: Float) -> Ray {
        return Ray(origin: lookFrom, direction: lowerLeft + u*horizontal + v*vertical - lookFrom)
    }
}
