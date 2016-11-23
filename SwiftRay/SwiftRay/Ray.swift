//
//  Ray.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

struct Ray {
    let origin: Vec3
    let direction: Vec3
    
    func pointAt(distance: Float) -> Vec3 {
        return origin + direction * distance
    }
}
