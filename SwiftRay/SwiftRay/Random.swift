//
//  Random.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 20/12/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Foundation

func random01() -> Float {
    return Float(arc4random())/Float(UInt32.max)
}

func randomMinus1Plus1() -> Float {
    return 2.0 * random01() - 1.0
}

func randomPointInsideUnitSphere() -> Vec3 {
    let radius = random01()
    return radius * normalize(Vec3(randomMinus1Plus1(), randomMinus1Plus1(), randomMinus1Plus1()))
}
