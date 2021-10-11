//
//  File.swift
//  
//
//  Created by narumij on 2021/09/27.
//

import SceneKit
import Metal

// MARK: -

public protocol UsesFloatComponents {
    static var usesFloatComponents: Bool { get }
}

extension FixedWidthInteger {
    public static var usesFloatComponents: Bool { false }
}

extension FloatingPoint {
    public static var usesFloatComponents: Bool { true }
}

extension SIMD where Scalar: UsesFloatComponents {
    public static var usesFloatComponents: Bool { Scalar.usesFloatComponents }
}

// MARK: -

public protocol BytesPerComponent {
    static var bytesPerComponent: Int { get }
}

extension FixedWidthInteger {
    public static var bytesPerComponent: Int { MemoryLayout<Self>.size }
}

extension FloatingPoint {
    public static var bytesPerComponent: Int { MemoryLayout<Self>.size }
}

extension SIMD where Scalar: BytesPerComponent {
    public static var bytesPerComponent: Int { Scalar.bytesPerComponent }
}

// MARK: -

public protocol ComponentsPerVecotr {
    static var componentsPerVector: Int { get }
}

extension Numeric {
    public static var componentsPerVector: Int { 1 }
}

extension SIMD where Scalar: BytesPerComponent {
    public static var componentsPerVector: Int { scalarCount }
}

// MARK: -

public protocol VertexScalar {
    static var VertexFormatArray: [MTLVertexFormat] { get }
}

extension Float
{
    public static var VertexFormatArray: [MTLVertexFormat]
    {
        [ .float, .float2, .float3, .float4 ]
    }
}

extension Int32
{
    public static var VertexFormatArray: [MTLVertexFormat]
    {
        [ .int, .int2, .int2, .int4 ]
    }
}

extension Int16
{
    public static var VertexFormatArray: [MTLVertexFormat]
    {
        [ .short, .short2, .short3, .short4 ]
    }
}

extension Int8
{
    public static var VertexFormatArray: [MTLVertexFormat]
    {
        [ .char, .char2, .char3, .char4 ]
    }
}

extension UInt32
{
    public static var VertexFormatArray: [MTLVertexFormat]
    {
        [ .ushort, .ushort2, .ushort3, .ushort4 ]
    }
}

extension UInt16
{
    public static var VertexFormatArray: [MTLVertexFormat]
    {
        [ .ushort, .ushort2, .ushort3, .ushort4 ]
    }
}

extension UInt8
{
    public static var VertexFormatArray: [MTLVertexFormat]
    {
        [ .ushort, .ushort2, .ushort3, .ushort4 ]
    }
}


// MARK: -

public protocol VertexFormat: SCNVertexDetail {
    static var vertexFormat: MTLVertexFormat { get }
}

extension Numeric where Self: VertexScalar {
    public static var vertexFormat: MTLVertexFormat { VertexFormatArray[0] }
}

extension SIMD where Scalar: VertexScalar {
    public static var vertexFormat: MTLVertexFormat { Scalar.VertexFormatArray[scalarCount - 1] }
}


// MARK: -

public typealias SCNVertexDetail = UsesFloatComponents & BytesPerComponent & ComponentsPerVecotr
public typealias MTLVertexDetail = VertexFormat & SCNVertexDetail

extension Int8:    SCNVertexDetail & MTLVertexDetail & VertexScalar { }
extension Int16:   SCNVertexDetail & MTLVertexDetail & VertexScalar { }
extension Int32:   SCNVertexDetail & MTLVertexDetail & VertexScalar { }
extension UInt8:   SCNVertexDetail & MTLVertexDetail & VertexScalar { }
extension UInt16:  SCNVertexDetail & MTLVertexDetail & VertexScalar { }
extension UInt32:  SCNVertexDetail & MTLVertexDetail & VertexScalar { }
extension Float32: SCNVertexDetail & MTLVertexDetail & VertexScalar { }
extension Int:     SCNVertexDetail { }
extension Float64: SCNVertexDetail { }
extension CGFloat: SCNVertexDetail { }

extension SIMD2: SCNVertexDetail & MTLVertexDetail where Scalar: SCNVertexDetail & VertexScalar { }
extension SIMD3: SCNVertexDetail & MTLVertexDetail where Scalar: SCNVertexDetail & VertexScalar { }
extension SIMD4: SCNVertexDetail & MTLVertexDetail where Scalar: SCNVertexDetail & VertexScalar { }

extension CGPoint:    SCNVertexDetail { }
extension SCNVector3: SCNVertexDetail { }
extension SCNVector4: SCNVertexDetail { }

