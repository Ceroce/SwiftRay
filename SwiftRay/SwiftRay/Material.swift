//
//  Material.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 23/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

protocol Material {
    // Return a new Ray, from the ori
    func scatteredRay(ray: Ray, intersection: HitIntersection) -> (Ray, Vec3)?
}
