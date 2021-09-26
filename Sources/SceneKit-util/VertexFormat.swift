//
//  File.swift
//  
//
//  Created by narumij on 2021/09/23.
//

import Metal

public protocol VertexFormat {
    static var vertexFormat: MTLVertexFormat { get }
}

public protocol VertexFormatArray {
    static var vertexFormatArray: [MTLVertexFormat] { get }
}

extension Float: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .float }
}

@available(macOS 11.0, *)
extension Float16: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .half }
}

extension Int32: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .int }
}

extension Int16: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .short }
}

extension Int8: VertexFormat {
    public static var vertexFormat: MTLVertexFormat { .char }
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

@available(macOS 11.0, *)
extension Float16: VertexFormatArray {
    public static var vertexFormatArray: [MTLVertexFormat] {
        [ .half, .half2, .half3, .half4 ]
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

extension UInt16: VertexFormatArray {
    public static var vertexFormatArray: [MTLVertexFormat] {
        [ .ushort, .ushort2, .ushort3, .ushort4 ]
    }
}
