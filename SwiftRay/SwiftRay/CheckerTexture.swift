//
//  File.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 10/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//

import Darwin // Maths

struct CheckerTexture: Texture {
    let tileSize: Float
    let oddTexture: Texture
    let evenTexture: Texture
    
    func value(u: Float, v: Float, point: Vec3) -> Vec3 {
        let period = 2 * tileSize
        let phase = sinf(period*point.x) * sinf(period*point.y) * sinf(period*point.z)
        if phase < 0 {
            return oddTexture.value(u: u, v: v, point: point)
        } else {
            return evenTexture.value(u: u, v: v, point: point)
        }
    }
}
