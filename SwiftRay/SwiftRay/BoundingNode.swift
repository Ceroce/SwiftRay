//
//  BoundingNode.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 01/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//


/// A Node of the Bounding Volume Hierarchy: a binary tree to make hit testing more efficient
struct BoundingNode: Hitable {
    let left: Hitable // A Node has necessary two branches, but they can point on the same Hitable if needed
    let right: Hitable
    let boundingBox: BoundingBox? // Not all Hitables have a BoundingBox
    
    init(hitables: [Hitable], startTime: Float, endTime: Float) {
        assert(hitables.count > 0)
        
        func compareBoxX(hitable0: Hitable, hitable1: Hitable) -> Bool {
            guard let box0 = hitable0.boundingBox(startTime: startTime, endTime: endTime) else {
                return true
            }
            
            guard let box1 = hitable1.boundingBox(startTime: startTime, endTime: endTime) else {
                return false
            }
            
            return box0.minPoint.x < box1.minPoint.x
        }
        
        func compareBoxY(hitable0: Hitable, hitable1: Hitable) -> Bool {
            guard let box0 = hitable0.boundingBox(startTime: startTime, endTime: endTime) else {
                return true
            }
            
            guard let box1 = hitable1.boundingBox(startTime: startTime, endTime: endTime) else {
                return false
            }
            
            return box0.minPoint.y < box1.minPoint.y
        }
        
        func compareBoxZ(hitable0: Hitable, hitable1: Hitable) -> Bool {
            guard let box0 = hitable0.boundingBox(startTime: startTime, endTime: endTime) else {
                return true
            }
            
            guard let box1 = hitable1.boundingBox(startTime: startTime, endTime: endTime) else {
                return false
            }
            
            return box0.minPoint.z < box1.minPoint.z
        }
        
        let count = hitables.count
        if count == 1 {
            // Left and right branches point at the same Hitable
            self.left = hitables[0]
            self.right = hitables[0]
            self.boundingBox = self.left.boundingBox(startTime: startTime, endTime: endTime)
        } else {
            // Pick randomly one axis
            let axis = Int(3*random01())
            let sortingFuncs = [compareBoxX, compareBoxY, compareBoxZ]
            let sortedHitables: [Hitable] = hitables.sorted(by: sortingFuncs[axis])
            
            if count == 2 {
                self.left = sortedHitables[0]
                self.right = sortedHitables[1]
            } else {
                let leftHitables = sortedHitables.prefix(count/2)
                let rightHitables = sortedHitables.suffix(from: count/2)
                self.left = BoundingNode(hitables: Array(leftHitables), startTime: startTime, endTime: endTime)
                self.right = BoundingNode(hitables: Array(rightHitables), startTime: startTime, endTime: endTime)
            }
            
            if let leftBox = left.boundingBox(startTime: startTime, endTime: endTime) {
                if let rightBox = right.boundingBox(startTime: startTime, endTime: endTime) {
                    // Both are set
                    self.boundingBox = BoundingBox.surroundingBox(box0: leftBox, box1: rightBox)
                } else {
                    // Only left
                    self.boundingBox = leftBox
                }
            } else {
                // Only right
                self.boundingBox = right.boundingBox(startTime: startTime, endTime: endTime)
            }
        }    
    }
    

    
    func hit(ray: Ray, distMin: Float, distMax: Float) -> HitIntersection? {
        guard let boundingBox = self.boundingBox else {
            return nil
        }
        
        guard boundingBox.isHitBy(ray: ray, distMin: distMin, distMax: distMax) else {
            return nil
        }
        
        let intersection: HitIntersection?
        if let leftIntersec = left.hit(ray: ray, distMin: distMin, distMax: distMax) {
            if let rightIntersec = right.hit(ray: ray, distMin: distMin, distMax: distMax) {
                intersection = leftIntersec.distance < rightIntersec.distance ? leftIntersec : rightIntersec
            } else {
                intersection = leftIntersec
            }
        } else {
            intersection = right.hit(ray: ray, distMin: distMin, distMax: distMax)
        }
        return intersection
    }
    
    func boundingBox(startTime: Float, endTime: Float) -> BoundingBox? {
        return self.boundingBox
    }
}
