//
//  Vector.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Darwin // For math functions

struct Vec3 {
    let x: Float
    let y: Float
    let z: Float
    
    init(_ x: Float, _ y:Float, _ z:Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(_ f: Float) {
        self.x = f
        self.y = f
        self.z = f
    }
}

extension Vec3 {
    static func + (u: Vec3, v: Vec3) -> Vec3 {
        return Vec3(u.x + v.x, u.y + v.y, u.z + v.z)
    }
    
    static func - (u: Vec3, v: Vec3) -> Vec3 {
        return Vec3(u.x - v.x, u.y - v.y, u.z - v.z)
    }
    
    static func * (u: Vec3, v: Vec3) -> Vec3 {
        return Vec3(u.x * v.x, u.y * v.y, u.z * v.z)
    }
    
    static func * (v: Vec3, f: Float) -> Vec3 {
        return Vec3(v.x * f, v.y * f, v.z * f)
    }
    
    static func * (f: Float, v: Vec3) -> Vec3 {
        return v * f
    }
    
    static func / (u: Vec3, v: Vec3) -> Vec3 {
        return Vec3(u.x / v.x, u.y / v.y, u.z / v.z)
    }
    
    static func / (v: Vec3, f: Float) -> Vec3 {
        return Vec3(v.x / f, v.y / f, v.z / f)
    }
}

func squaredLength(_ v: Vec3) -> Float {
    return v.x*v.x + v.y*v.y + v.z*v.z
}

func length(_ v: Vec3) -> Float {
    return sqrtf(squaredLength(v))
}

func normalize(_ v: Vec3) -> Vec3 {
    return v / length(v)
}

func dot(_ u: Vec3, _ v: Vec3) -> Float {
    return u.x*v.x + u.y*v.y + u.z*v.z
}

func cross(_ u: Vec3, _ v: Vec3) -> Vec3 {
    return Vec3(u.y * v.z - v.y * u.z,
                u.z * v.x - v.z * u.x,
                u.x * v.y - v.x * u.y)
}

func mix(_ u: Vec3, _ v: Vec3, _ alpha: Float) -> Vec3 {
    return (1.0-alpha)*u + alpha*v
}
