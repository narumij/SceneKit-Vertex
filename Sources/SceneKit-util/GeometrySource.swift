//
//  File.swift
//  
//
//  Created by narumij on 2021/09/23.
//

import SceneKit
import Metal

public typealias SemanticDetail = (semantic: SCNGeometrySource.Semantic, vertexFormat: MTLVertexFormat, dataOffset: Int)

public protocol Semantic {
    static var semanticDetail: [SemanticDetail] { get }
}

extension Semantic {
    
    static var dataStride: Int { MemoryLayout<Self>.stride }
    
    public static func vertexCount(of vertexBuffer: MTLBuffer) -> Int { vertexBuffer.length / dataStride }
    
    public static func geometrySources(of vertexBuffer: MTLBuffer ) -> [SCNGeometrySource] {
        Self.geometrySources(of: vertexBuffer, vertexCount: vertexCount(of: vertexBuffer) )
    }

}


extension Array where Element: Semantic {
    
    public func geometrySources( with device: MTLDevice ) -> [SCNGeometrySource] {
        buffer( with: device ).map{ Element.geometrySources(of: $0, vertexCount: count ) } ?? []
    }
    
}

extension Semantic {
    
    static func geometrySources(of vertexBuffer: MTLBuffer, vertexCount c: Int) -> [SCNGeometrySource] {
        
        semanticDetail.map {
            SCNGeometrySource(buffer: vertexBuffer,
                              vertexFormat: $0.vertexFormat,
                              semantic:     $0.semantic,
                              vertexCount:  c,
                              dataOffset:   $0.dataOffset,
                              dataStride:   dataStride )
        }
        
    }

}


// MARK: -

public protocol Position: Semantic {
    associatedtype PositionType: VertexFormat, SIMD
    var position: PositionType { get }
    static var positionKeyPath: PartialKeyPath<Self> { get }
}

public protocol Normal: Semantic {
    associatedtype NormalType: VertexFormat, SIMD
    var normal: NormalType { get }
    static var normalKeyPath: PartialKeyPath<Self> { get }
}

public protocol Texcoord: Semantic {
    associatedtype TexcoordType: VertexFormat
    var texcoord: TexcoordType { get }
    static var texcoordKeyPath: PartialKeyPath<Self> { get }
}

public protocol Color: Semantic {
    associatedtype ColorType: VertexFormat
    var color: ColorType { get }
    static var colorKeyPath: PartialKeyPath<Self> { get }
}


// MARK: -

extension Position {
    static var positionInfo: SemanticDetail {
        (.vertex, PositionType.vertexFormat, MemoryLayout.offset(of: positionKeyPath)! )
    }
}

extension Texcoord {
    static var texcoordInfo: SemanticDetail {
        (.texcoord, TexcoordType.vertexFormat, MemoryLayout.offset(of: texcoordKeyPath)! )
    }
}

extension Normal {
    static var normalInfo: SemanticDetail {
        (.normal, NormalType.vertexFormat, MemoryLayout.offset(of: normalKeyPath)! )
    }
}


// MARK: -

public extension Semantic where Self: Position {
    static var semanticDetail: [SemanticDetail] { [positionInfo] }
}

public extension Semantic where Self: Position, Self: Normal {
    static var semanticDetail: [SemanticDetail] { [positionInfo, normalInfo] }
}

public extension Semantic where Self: Position, Self: Texcoord {
    static var semanticDetail: [SemanticDetail] { [positionInfo, texcoordInfo] }
}
