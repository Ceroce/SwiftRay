//
//  Scene.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 24/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

protocol Scene {
    var camera: Camera {get}
    var hitables: [Hitable] {get}
    
    init(aspectRatio: Float)
}
