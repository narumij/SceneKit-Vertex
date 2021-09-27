//
//  File.swift
//  
//
//  Created by narumij on 2021/09/27.
//

import SceneKit
import Metal

extension Int {
    
    func primitiveCount(of type: SCNGeometryPrimitiveType ) -> Int
    {
        switch type {
        case .triangleStrip:
            return (self - 2)
        case .triangles:
            return self / 3
        case .line:
            return self / 2
        default:
            return self
        }
        
    }
    
}


extension FixedWidthInteger {
    static var dataStride: Int { MemoryLayout<Self>.stride }
    public static func elementCount(of elementBuffer: MTLBuffer) -> Int
    {
        elementBuffer.length / dataStride
    }
}



// MARK: -

public protocol GeometrySourceVector {
    static var componentsPerVector: Int { get }
    associatedtype Scalar
}

extension GeometrySourceVector {
    public static var usesFloatComponents: Bool {
        (Self.self as? UsesFloatComponents.Type)?.usesFloatComponents ?? false
    }
    public static var bytesPerComponent: Int {
        MemoryLayout<Scalar>.size
    }
}

public protocol UsesFloatComponents {
    static var usesFloatComponents: Bool { get }
}

extension GeometrySourceVector where Self: UsesFloatComponents, Scalar: BinaryFloatingPoint {
    public static var usesFloatComponents: Bool { true }
}

extension CGPoint: GeometrySourceVector, UsesFloatComponents {
    public typealias Scalar = CGFloat
    public static var componentsPerVector: Int { 2 }
}

extension SCNVector3: GeometrySourceVector, UsesFloatComponents {
    public static var componentsPerVector: Int { 3 }
}

extension SCNVector4: GeometrySourceVector, UsesFloatComponents {
    public static var componentsPerVector: Int { 4 }
}

extension SIMD2: GeometrySourceVector {
    public static var componentsPerVector: Int { 2 }
}

extension SIMD3: GeometrySourceVector {
    public static var componentsPerVector: Int { 3 }
}

extension SIMD4: GeometrySourceVector {
    public static var componentsPerVector: Int { 4 }
}

extension SIMD2: UsesFloatComponents where Scalar: BinaryFloatingPoint { }
extension SIMD3: UsesFloatComponents where Scalar: BinaryFloatingPoint { }
extension SIMD4: UsesFloatComponents where Scalar: BinaryFloatingPoint { }

public protocol VertexFormat {
    static var vertexFormat: MTLVertexFormat { get }
    static var usesFloatComponents: Bool { get }
    static var componentsPerVector: Int { get }
    static var bytesPerComponent: Int { get }
}

public protocol VertexFormatArray {
    static var vertexFormatArray: [MTLVertexFormat] { get }
}

extension Double: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { fatalError() }
    public static var usesFloatComponents: Bool { true }
    public static var componentsPerVector: Int { 1 }
    public static var bytesPerComponent: Int { MemoryLayout<Self>.size }
}

extension Float: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .float }
    public static var usesFloatComponents: Bool { true }
    public static var componentsPerVector: Int { 1 }
    public static var bytesPerComponent: Int { MemoryLayout<Self>.size }
}

extension Int: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .int }
    public static var usesFloatComponents: Bool { false }
    public static var componentsPerVector: Int { 1 }
    public static var bytesPerComponent: Int { MemoryLayout<Self>.size }
}

extension Int32: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .int }
    public static var usesFloatComponents: Bool { false }
    public static var componentsPerVector: Int { 1 }
    public static var bytesPerComponent: Int { MemoryLayout<Self>.size }
}

extension Int16: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .short }
    public static var usesFloatComponents: Bool { false }
    public static var componentsPerVector: Int { 1 }
    public static var bytesPerComponent: Int { MemoryLayout<Self>.size }
}

extension Int8: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .char }
    public static var usesFloatComponents: Bool { false }
    public static var componentsPerVector: Int { 1 }
    public static var bytesPerComponent: Int { MemoryLayout<Self>.size }
}

extension SIMD where Scalar: VertexFormatArray {
    public static var vertexFormat: MTLVertexFormat { Scalar.vertexFormatArray[scalarCount - 1] }
}

extension SIMD2: VertexFormat where Scalar: VertexFormatArray { }
extension SIMD3: VertexFormat where Scalar: VertexFormatArray { }
extension SIMD4: VertexFormat where Scalar: VertexFormatArray { }

extension Float: VertexFormatArray {
    public static var vertexFormatArray: [MTLVertexFormat] {
        [ .float, .float2, .float3, .float4 ]
    }
}

extension Int32: VertexFormatArray {
    public static var vertexFormatArray: [MTLVertexFormat] {
        [ .int, .int2, .int2, .int4 ]
    }
}

extension Int16: VertexFormatArray {
    public static var vertexFormatArray: [MTLVertexFormat] {
        [ .short, .short2, .short3, .short4 ]
    }
}

extension Int8: VertexFormatArray {
    public static var vertexFormatArray: [MTLVertexFormat] {
        [ .char, .char2, .char3, .char4 ]
    }
}

extension UInt32: VertexFormatArray {
    public static var vertexFormatArray: [MTLVertexFormat] {
        [ .ushort, .ushort2, .ushort3, .ushort4 ]
    }
}

extension UInt16: VertexFormatArray {
    public static var vertexFormatArray: [MTLVertexFormat] {
        [ .ushort, .ushort2, .ushort3, .ushort4 ]
    }
}

extension UInt8: VertexFormatArray {
    public static var vertexFormatArray: [MTLVertexFormat] {
        [ .ushort, .ushort2, .ushort3, .ushort4 ]
    }
}


