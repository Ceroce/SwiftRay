//
//  BoundingVolumeHierarchy.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 01/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//

/// A binary tree to make hit testing more efficient
struct BoundingVolumeHierarchy: Hitable {
    
    indirect enum Tree {
        case leaf(Hitable, BoundingBox)
        case branch(Tree, Tree, BoundingBox)
    }
    
    var root: Tree? = nil

    private func boxOf(tree: Tree) -> BoundingBox {
        let box: BoundingBox
        switch tree {
        case .leaf(_, let leafBox):
            box = leafBox
        case .branch(_, _, let branchBox):
            box = branchBox
        }
        
        return box
    }
    
    private func treeWith(hitables: [Hitable], startTime: Float, endTime: Float) -> Tree {
        func compareBoxX(hitable0: Hitable, hitable1: Hitable) -> Bool {
            let box0 = hitable0.boundingBox(startTime: startTime, endTime: endTime)
            let box1 = hitable1.boundingBox(startTime: startTime, endTime: endTime)
            return box0.minPoint.x < box1.minPoint.x
        }
        
        func compareBoxY(hitable0: Hitable, hitable1: Hitable) -> Bool {
            let box0 = hitable0.boundingBox(startTime: startTime, endTime: endTime)
            let box1 = hitable1.boundingBox(startTime: startTime, endTime: endTime)
            return box0.minPoint.y < box1.minPoint.y
        }
        
        func compareBoxZ(hitable0: Hitable, hitable1: Hitable) -> Bool {
            let box0 = hitable0.boundingBox(startTime: startTime, endTime: endTime)
            let box1 = hitable1.boundingBox(startTime: startTime, endTime: endTime)
            return box0.minPoint.z < box1.minPoint.z
        }
        
        let count = hitables.count
        if count == 1 {
            let hitable = hitables[0]
            return Tree.leaf(hitable, hitable.boundingBox(startTime: startTime, endTime: endTime))
        } else {
            // Pick randomly one axis
            let axis = Int(3*random01())
            let sortingFuncs = [compareBoxX, compareBoxY, compareBoxZ]
            let sortedHitables: [Hitable] = hitables.sorted(by: sortingFuncs[axis])
            
            let leftHitables = Array(sortedHitables.prefix(count/2))
            let leftTree = treeWith(hitables: leftHitables, startTime: startTime, endTime: endTime)
            
            let rightHitables = Array(sortedHitables.suffix(from: count/2))
            let rightTree = treeWith(hitables: rightHitables, startTime: startTime, endTime: endTime)
            
            return Tree.branch(leftTree, rightTree, BoundingBox.surroundingBox(box0: boxOf(tree: leftTree), box1: boxOf(tree: rightTree)))
        }
    }
    
    init(hitables: [Hitable], startTime: Float, endTime: Float) {
        assert(hitables.count > 0)
        self.root = treeWith(hitables: hitables, startTime: startTime, endTime: endTime)
    }
    
    private func hit(tree: Tree, ray: Ray, distMin: Float, distMax: Float) -> HitIntersection? {
        switch tree {
        case .leaf(let hitable, _):
            return hitable.hit(ray: ray, distMin: distMin, distMax: distMax)
        case .branch(let left, let right, let bbox):
            let isHit = bbox.isHitBy(ray: ray, distMin: distMin, distMax: distMax)
            if isHit == false {
                return nil
            } else {
                if let leftIntersec = hit(tree: left, ray: ray, distMin: distMin, distMax: distMax) {
                    if let rightIntersec = hit(tree: right, ray: ray, distMin: distMin, distMax: distMax) {
                        return leftIntersec.distance < rightIntersec.distance ? leftIntersec : rightIntersec
                    } else {
                        return leftIntersec
                    }
                } else {
                    return hit(tree: right, ray: ray, distMin: distMin, distMax: distMax)
                }
            }
        }
    }
    
    func hit(ray: Ray, distMin: Float, distMax: Float) -> HitIntersection? {
        return hit(tree: self.root!, ray: ray, distMin: distMin, distMax: distMax)
    }
    
    func boundingBox(startTime: Float, endTime: Float) -> BoundingBox {
        return self.boxOf(tree: self.root!)
    }
}
