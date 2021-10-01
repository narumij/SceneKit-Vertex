//
//  File.swift
//  
//
//  Created by narumij on 2021/09/26.
//

import SceneKit


extension SCNVector3: SIMD
{
    public typealias MaskStorage = SIMD3<SCNFloat.NativeType>.MaskStorage
    public subscript(index: Int) -> SCNFloat
    {
        get {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            default: fatalError()
            }
        }
        set(newValue) {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            default: fatalError()
            }
        }
    }
    public var scalarCount: Int { 3 }
    public typealias Scalar = SCNFloat
}


extension SCNVector4: SIMD {
    public typealias MaskStorage = SIMD4<SCNFloat.NativeType>.MaskStorage
    public subscript(index: Int) -> SCNFloat
    {
        get {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            case 3: return w
            default: fatalError()
            }
        }
        set(newValue) {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            case 3: w = newValue
            default: fatalError()
            }
        }
    }
    public var scalarCount: Int { 4 }
    public typealias Scalar = SCNFloat
    
}

