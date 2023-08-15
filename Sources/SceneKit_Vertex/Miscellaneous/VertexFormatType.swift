//
//  Created by narumij on 2023/06/11.
//

import SceneKit
import Metal

public protocol VertexFormatType {
    
    static var vertexFormat: MTLVertexFormat { get }
}

extension Int8:    VertexFormatType { }
extension Int16:   VertexFormatType { }
extension Int32:   VertexFormatType { }

extension UInt8:   VertexFormatType { }
extension UInt16:  VertexFormatType { }
extension UInt32:  VertexFormatType { }

@available(macOS, unavailable) // intel macだとコンパイルが通らない
@available(macCatalyst, unavailable)
@available(iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension Float16: VertexFormatType { }

extension Float32: VertexFormatType { }

// Float64はインターリーブで利用できないため省略
// Float80、Float96も同様

extension SIMD2: VertexFormatType where Scalar: DefaultVetexFormats { }
extension SIMD3: VertexFormatType where Scalar: DefaultVetexFormats { }
extension SIMD4: VertexFormatType where Scalar: DefaultVetexFormats { }

// MARK: -

public protocol DefaultVetexFormats {
    
    static var defaultVertexFotmats: [MTLVertexFormat] { get }
}

extension DefaultVetexFormats {

    public static var vertexFormat: MTLVertexFormat {
        defaultVertexFotmats[0]
    }
}

extension SIMD where Scalar: DefaultVetexFormats {
    
    public static var vertexFormat: MTLVertexFormat {
        Scalar.defaultVertexFotmats[scalarCount - 1]
    }
}

// MARK: -

@available(macOS, unavailable) // intel macだとコンパイルが通らない
@available(macCatalyst, unavailable)
@available(iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension Float16: DefaultVetexFormats
{
    public static var defaultVertexFotmats: [MTLVertexFormat]
    {
        [ .half, .half2, .half3, .half4 ]
    }
}

extension Float32: DefaultVetexFormats
{
    public static var defaultVertexFotmats: [MTLVertexFormat]
    {
        [ .float, .float2, .float3, .float4 ]
    }
}

extension Int8: DefaultVetexFormats
{
    public static var defaultVertexFotmats: [MTLVertexFormat]
    {
        [ .char, .char2, .char3, .char4 ]
    }
}

extension Int16: DefaultVetexFormats
{
    public static var defaultVertexFotmats: [MTLVertexFormat]
    {
        [ .short, .short2, .short3, .short4 ]
    }
}

extension Int32: DefaultVetexFormats
{
    public static var defaultVertexFotmats: [MTLVertexFormat]
    {
        [ .int, .int2, .int2, .int4 ]
    }
}

extension UInt8: DefaultVetexFormats
{
    public static var defaultVertexFotmats: [MTLVertexFormat]
    {
        [ .uchar, .uchar2, .uchar3, .uchar4 ]
    }
}

extension UInt16: DefaultVetexFormats
{
    public static var defaultVertexFotmats: [MTLVertexFormat]
    {
        [ .ushort, .ushort2, .ushort3, .ushort4 ]
    }
}

extension UInt32: DefaultVetexFormats
{
    public static var defaultVertexFotmats: [MTLVertexFormat]
    {
        [ .uint, .uint2, .uint3, .uint4 ]
    }
}

extension CGPoint {
    // osx 10.15以降では、32bit未サポートなため、要素がDoubleとなる。
    // インターリーブの対象外となるため、VertexFormatTypeを適用しない
}

#if !os(macOS)
// macOSでは、要素がCGFloat（Double)となる。
// インターリーブの対象外となるため、除外する
extension SCNVector3: VertexFormatType {
    public static var vertexFormat: MTLVertexFormat {
        SCNFloat.self == Float.self ? .float3 : .invalid
    }
}
extension SCNVector4: VertexFormatType {
    public static var vertexFormat: MTLVertexFormat {
        SCNFloat.self == Float.self ? .float4 : .invalid
    }
}
#endif
