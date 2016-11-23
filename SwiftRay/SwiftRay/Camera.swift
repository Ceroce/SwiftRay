//
//  Camera.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

class Camera {
    var origin: Vec3
    var lowerLeft: Vec3
    var horizontal: Vec3
    var vertical: Vec3
    
    init() {
        origin = Vec3(0.0, 0.0, 0.0)
        lowerLeft = Vec3(-2.0, -1.0, -1.0)
        horizontal = Vec3(4.0, 0.0, 0.0)
        vertical = Vec3(0.0, 2.0, 0.0)
    }
    
    func ray(u: Float, v: Float) -> Ray {
        return Ray(origin: origin, direction: lowerLeft + u*horizontal + v*vertical)
    }
}
