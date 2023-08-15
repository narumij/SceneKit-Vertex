//
//  Created by narumij on 2023/06/11.
//

import SceneKit

public protocol ComponentType {
    
    static var usesFloatComponents: Bool { get }
    static var bytesPerComponent:   Int  { get }
    static var componentsPerVector: Int  { get }
}

// MARK: -

extension FixedWidthInteger
{
    public static var usesFloatComponents: Bool { false }
    public static var componentsPerVector: Int  { 1 }
    public static var bytesPerComponent:   Int  { MemoryLayout<Self>.size }
}

extension BinaryFloatingPoint
{
    public static var usesFloatComponents: Bool { true }
    public static var componentsPerVector: Int  { 1 }
    public static var bytesPerComponent:   Int  { MemoryLayout<Self>.size }
}

extension SIMD where Scalar: ComponentType
{
    public static var usesFloatComponents: Bool { Scalar.usesFloatComponents }
    public static var bytesPerComponent:   Int  { Scalar.bytesPerComponent }
    public static var componentsPerVector: Int  { scalarCount }
}

extension Int {
    // インターリーブでの利用は可能だが、
    // VertexFormatTypeに該当が無いため、シェーダーで利用できず、無駄なので
    // ComponentType適用除外とする
}

extension Int8:    ComponentType { }
extension Int16:   ComponentType { }
extension Int32:   ComponentType { }

extension UInt8:   ComponentType { }
extension UInt16:  ComponentType { }
extension UInt32:  ComponentType { }

@available(macOS, unavailable) // intel macだとコンパイルが通らない
@available(macCatalyst, unavailable)
@available(iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension Float16: ComponentType {
    public static var usesFloatComponents: Bool { true }
    public static var componentsPerVector: Int  { 1 }
    public static var bytesPerComponent:   Int  { MemoryLayout<Self>.size }
}

extension Float32: ComponentType { }

extension SIMD2: ComponentType where Scalar: ComponentType { }
extension SIMD3: ComponentType where Scalar: ComponentType { }
extension SIMD4: ComponentType where Scalar: ComponentType { }

extension CGPoint {
    // osx 10.15以降では、32bit未サポートなため、要素がDoubleとなる。
    // インターリーブの対象外となるため、ComponentTypeを適用しない
}

#if !os(macOS)
// macOSでは、要素がCGFloat（Double)となる。
// インターリーブの対象外となるため、除外する
extension SCNVector3: ComponentType {
    public static var usesFloatComponents: Bool { SCNFloat.usesFloatComponents }
    public static var bytesPerComponent:   Int  { SCNFloat.bytesPerComponent }
    public static var componentsPerVector: Int  { 3 }
}
extension SCNVector4: ComponentType {
    public static var usesFloatComponents: Bool { SCNFloat.usesFloatComponents }
    public static var bytesPerComponent:   Int  { SCNFloat.bytesPerComponent }
    public static var componentsPerVector: Int  { 4 }
}
#endif
