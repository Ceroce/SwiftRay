//
//  Texture.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 10/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//

protocol Texture {
    func value(u: Float, v: Float, point: Vec3) -> Vec3
}
