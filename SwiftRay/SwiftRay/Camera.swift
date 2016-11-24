//
//  Camera.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Darwin // Maths

struct Camera {
    let origin: Vec3
    let lowerLeft: Vec3
    let horizontal: Vec3
    let vertical: Vec3
    
    // yFov in degres. aspectRatio = width/height
    init(yFov: Float, aspectRatio: Float) {
        let theta = rad(yFov)
        let halfHeight = tanf(theta/2)
        let halfWidth = aspectRatio * halfHeight
        
        lowerLeft = Vec3(-halfWidth, -halfHeight, -1.0)
        horizontal = Vec3(2*halfWidth, 0.0, 0.0)
        vertical = Vec3(0.0, 2.0*halfHeight, 0.0)
        origin = Vec3(0.0)
    }
    
    func ray(u: Float, v: Float) -> Ray {
        return Ray(origin: origin, direction: lowerLeft + u*horizontal + v*vertical)
    }
}
