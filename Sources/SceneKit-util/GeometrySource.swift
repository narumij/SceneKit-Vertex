//
//  File.swift
//  
//
//  Created by narumij on 2021/09/23.
//

import SceneKit
import Metal

/// 構造体化された頂点を利用する
public struct Interleaved<T: Interleave>
{
    fileprivate let source: InterleaveSource
    
    public init(array aa: [T]) {
        source = aa
    }
    
    public init(buffer b: MTLBuffer) {
        source = TypedBuffer<T>(b)
    }
    
    public func geometrySources() -> [SCNGeometrySource]
    {
        source.geometrySources()
    }

    public func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement?
    {
        source.geometryElement(primitiveType: type)
    }

}


/// 複数のベクトル配列を利用する
public struct Separated {
    
    let items: [Semantic]
    
    public init(items ii: [Semantic]) {
        items = ii
    }
    
    public init(arrays aa: [ArraySemantic]) {
        self.init(items: aa )
    }

    public init(buffers bb: [BufferSemantic]) {
        self.init(items: bb )
    }

    public func geometrySources() -> [SCNGeometrySource]
    {
        items.map{ $0.geometrySource() }
    }
    
    public func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement?
    {
        items.first?.geometryElement(primitiveType: type)
    }
    
}



// MARK: -

public protocol GeometrySource
{
    /// SCNGeometrySourceの配列を生成する
    func geometrySources() -> [SCNGeometrySource]
    /// 頂点データを先頭から末尾まで指定した描画プリミティブで描画するSCNGeometryElementを生成する。
    /// @result バッファ生成に失敗した場合のみ、nilが返る。
    func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement?
}

extension Separated: GeometrySource { }
extension Interleaved: GeometrySource { }



// MARK: -

fileprivate protocol InterleaveSource
{
    func geometrySources() -> [SCNGeometrySource]
    func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement
}

extension TypedBuffer: InterleaveSource where Element: Interleave { }
extension Array: InterleaveSource where Element: Interleave { }



// MARK: -

extension Separated
{
    
    public init<T: VertexDetail>(vertex: [T]) {
        self.init(items: [.vertex(vertex)] )
    }
    
    public init<T: VertexDetail,S: VertexDetail>(vertex: [T], normal: [S]) {
        self.init(items: [.vertex(vertex), .normal(normal)] )
    }
    
    public init<T: VertexDetail,S: VertexDetail>(vertex: [T], texcoord: [S]) {
        self.init(items: [.vertex(vertex), .texcoord(texcoord)] )
    }
    
    public init<T: VertexDetail,S: VertexDetail, U: VertexDetail>(vertex: [T], normal: [S], texcoord: [U]) {
        self.init(items: [.vertex(vertex), .normal(normal), .texcoord(texcoord)] )
    }
    
    public init<T: VertexDetail,S: VertexDetail>(vertex: [T], color: [S]) {
        self.init(items: [.vertex(vertex), .color(color)] )
    }
    
    public init<T: VertexDetail,S: VertexDetail, U: VertexDetail>(vertex: [T], normal: [S], color: [U]) {
        self.init(items: [.vertex(vertex), .normal(normal), .color(color)] )
    }
    
}


// MARK: - 配列毎の型の差異を吸収するためにある。

fileprivate protocol SemanticSource
{
    func geometrySource(semantic: SCNGeometrySource.Semantic) -> SCNGeometrySource
    var count: Int { get }
}

extension Array: SemanticSource where Element: VertexDetail { }

extension TypedBuffer: SemanticSource where Element: VertexFormat { }

extension Separated
{

    public class Semantic
    {
        
        fileprivate var source: SemanticSource { fatalError() }
        
        var vertexCount: Int { source.count }
        let semantic: SCNGeometrySource.Semantic
        
        init(semantic s: SCNGeometrySource.Semantic) {
            semantic = s
        }
        
    }

    // MARK: -

    public class ArraySemantic: Semantic { }

    public class BufferSemantic: Semantic { }

    
    // MARK: -

    public class ArrayItem<T: VertexDetail>: ArraySemantic
    {
        
        init(semantic s: SCNGeometrySource.Semantic,
             array a: [T] ) {
            array = a
            super.init(semantic: s)
        }
        
        fileprivate override var source: SemanticSource { array }
        
        private let array: [T]
        
    }

    public class BufferItem<T: VertexFormat>: BufferSemantic
    {
        
        init(semantic s: SCNGeometrySource.Semantic,
             buffer b: TypedBuffer<T> ) {
            buffer = b
            super.init(semantic: s)
        }
        
        fileprivate override var source: SemanticSource { buffer }
        
        private let buffer: TypedBuffer<T>
        
    }


}



// MARK: -

extension SemanticSource
{
    func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement
    {
        count.geometryElement(primitiveType: type)
    }
    
}



// MARK: -

extension Separated.Semantic
{
    
    func geometrySource() -> SCNGeometrySource
    {
        source.geometrySource(semantic: semantic)
    }
    
    func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement
    {
        source.geometryElement(primitiveType: type)
    }

    
    static func vertex<T>(_ array: [T]) -> Separated.ArraySemantic where T: VertexDetail
    {
        Separated.ArrayItem(semantic: .vertex, array: array);
    }
    
    static func normal<T>(_ array: [T]) -> Separated.ArraySemantic where T: VertexDetail
    {
        Separated.ArrayItem(semantic: .normal, array: array);
    }
    
    static func color<T>(_ array: [T]) -> Separated.ArraySemantic where T: VertexDetail
    {
        Separated.ArrayItem(semantic: .color, array: array);
    }
    
    static func texcoord<T>(_ array: [T]) -> Separated.ArraySemantic where T: VertexDetail
    {
        Separated.ArrayItem(semantic: .texcoord, array: array);
    }

    
    static func vertex<T>(_ buffer: TypedBuffer<T>) -> Separated.BufferSemantic where T: VertexFormat
    {
        Separated.BufferItem(semantic: .vertex, buffer: buffer);
    }
    
    static func normal<T>(_ buffer: TypedBuffer<T>) -> Separated.BufferSemantic where T: VertexFormat
    {
        Separated.BufferItem(semantic: .normal, buffer: buffer);
    }
    
    static func color<T>(_ buffer: TypedBuffer<T>) -> Separated.BufferSemantic where T: VertexFormat
    {
        Separated.BufferItem(semantic: .color, buffer: buffer);
    }
    
    static func texcoord<T>(_ buffer: TypedBuffer<T>) -> Separated.BufferSemantic where T: VertexFormat
    {
        Separated.BufferItem(semantic: .texcoord, buffer: buffer);
    }
    
}


