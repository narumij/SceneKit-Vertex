//
//  File.swift
//  
//
//  Created by narumij on 2021/09/27.
//

import SceneKit
import Metal

public typealias SemanticDetail = (semantic: SCNGeometrySource.Semantic,
                                   vertexFormat: MTLVertexFormat,
                                   usesFloatComponents: Bool,
                                   componentsPerVector: Int,
                                   bytesPerComponent: Int,
                                   dataOffset: Int)

public protocol Interleave {
    static var semanticDetails: [SemanticDetail] { get }
}

extension Interleave {
    
    static var dataStride: Int { MemoryLayout<Self>.stride }
    
    public static func vertexCount(of vertexBuffer: MTLBuffer) -> Int { vertexBuffer.length / dataStride }
    
}

// MARK: -

public protocol Position: Interleave {
    associatedtype PositionType: VertexFormat, SIMD
    var position: PositionType { get }
    static var positionKeyPath: PartialKeyPath<Self> { get }
}

public protocol Normal: Interleave {
    associatedtype NormalType: VertexFormat, SIMD
    var normal: NormalType { get }
    static var normalKeyPath: PartialKeyPath<Self> { get }
}

public protocol Texcoord: Interleave {
    associatedtype TexcoordType: VertexFormat
    var texcoord: TexcoordType { get }
    static var texcoordKeyPath: PartialKeyPath<Self> { get }
}

public protocol Color: Interleave {
    associatedtype ColorType: VertexFormat
    var color: ColorType { get }
    static var colorKeyPath: PartialKeyPath<Self> { get }
}


// MARK: -

extension Position {
    static var positionInfo: SemanticDetail {
        (.vertex,
         PositionType.vertexFormat,
         PositionType.usesFloatComponents,
         PositionType.componentsPerVector,
         PositionType.bytesPerComponent,
         MemoryLayout.offset(of: positionKeyPath)! )
    }
}

extension Texcoord {
    static var texcoordInfo: SemanticDetail {
        (.texcoord,
         TexcoordType.vertexFormat,
         TexcoordType.usesFloatComponents,
         TexcoordType.componentsPerVector,
         TexcoordType.bytesPerComponent,
         MemoryLayout.offset(of: texcoordKeyPath)! )
    }
}

extension Normal {
    static var normalInfo: SemanticDetail {
        (.normal,
         NormalType.vertexFormat,
         NormalType.usesFloatComponents,
         NormalType.componentsPerVector,
         NormalType.bytesPerComponent,
         MemoryLayout.offset(of: normalKeyPath)! )
    }
}


// MARK: -

public extension Interleave where Self: Position {
    static var semanticDetails: [SemanticDetail] { [positionInfo] }
}

public extension Interleave where Self: Position, Self: Normal {
    static var semanticDetails: [SemanticDetail] { [positionInfo, normalInfo] }
}

public extension Interleave where Self: Position, Self: Texcoord {
    static var semanticDetails: [SemanticDetail] { [positionInfo, texcoordInfo] }
}
