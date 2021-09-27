//
//  File.swift
//  
//
//  Created by narumij on 2021/09/23.
//

import SceneKit
import Metal

public protocol GeometrySource {
    var impl: Impl { get }
}

extension GeometrySource {
    func geometrySources() -> [SCNGeometrySource] {
        impl.geometrySources()
    }
    func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement? {
        impl.geometryElement(primitiveType: type)
    }
}

public struct Interleaved<T: Interleave>: GeometrySource {
    
    public let impl: Impl
    
    public init(array: [T]) {
        impl = InterleaveImpl(array: array)
    }
    
    public init(buffer: MTLBuffer) {
        impl = MetalInterleaveImpl<T>(of: buffer)
    }
}

public struct Separated: GeometrySource {

    public let impl: Impl

    public init(items ii: [Item]) {
        impl = SemanticsImpl( ii )
    }

}

// MARK: -

extension Separated {
    
    public init<T: GeometrySourceVector>(vertex: [T]) {
        self.init(items: [.vertex(vertex)] )
    }
    
    public init<T: GeometrySourceVector,S: GeometrySourceVector>(vertex: [T], normal: [S]) {
        self.init(items: [.vertex(vertex), .normal(normal)] )
    }
    
    public init<T: GeometrySourceVector,S: GeometrySourceVector>(vertex: [T], texcoord: [S]) {
        self.init(items: [.vertex(vertex), .texcoord(texcoord)] )
    }
    
    public init<T: GeometrySourceVector,S: GeometrySourceVector, U: GeometrySourceVector>(vertex: [T], normal: [S], texcoord: [U]) {
        self.init(items: [.vertex(vertex), .normal(normal), .texcoord(texcoord)] )
    }
    
    public init<T: GeometrySourceVector,S: GeometrySourceVector>(vertex: [T], color: [S]) {
        self.init(items: [.vertex(vertex), .color(color)] )
    }
    
    public init<T: GeometrySourceVector,S: GeometrySourceVector, U: GeometrySourceVector>(vertex: [T], normal: [S], color: [U]) {
        self.init(items: [.vertex(vertex), .normal(normal), .color(color)] )
    }
    
}


// MARK: - 配列毎の型の差異を吸収するためにある。

public class Item {
    
    func geometrySource() -> SCNGeometrySource { fatalError() }
    func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement { fatalError() }
    
    // MARK: -
    
    static func vertex<T>(_ array: [T]) -> Item where T: GeometrySourceVector {
        Semantic(semantic: .vertex, array: array);
    }
    static func normal<T>(_ array: [T]) -> Item where T: GeometrySourceVector {
        Semantic(semantic: .normal, array: array);
    }
    static func color<T>(_ array: [T]) -> Item where T: GeometrySourceVector {
        Semantic(semantic: .color, array: array);
    }
    static func texcoord<T>(_ array: [T]) -> Item where T: GeometrySourceVector {
        Semantic(semantic: .texcoord, array: array);
    }
    
}


public class Semantic<T: GeometrySourceVector>: Item {
    init(semantic s: SCNGeometrySource.Semantic, array a: [T] ) {
        semantic = s
        array = a
        super.init()
    }
    private let semantic: SCNGeometrySource.Semantic
    private let array: [T]
    public override func geometrySource() -> SCNGeometrySource {
        array.geometrySource(semantic: semantic)
    }
    public override func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement {
        type == .lineStrip
        ? lineStripElement(count: array.count)
        : ( 0 ..< array.count ).map({ UInt32( $0 ) }).geometryElement(primitiveType: .init(type) )
    }
}



func lineStripIndices(count:Int) -> [Int] {
    func idx(_ n: Int) -> Int {
        return n / 2 + n % 2
    }
    return Array<Int>( 0 ..< (count-1)*2).map{ idx($0) }
}

func lineStripElement(count:Int) -> SCNGeometryElement {
    lineStripIndices(count: count)
        .map({Int32($0)})
        .geometryElement(primitiveType: .line)
}


// MARK: - インターリーブ型と、分離型の双方を扱うためにある

public class Impl {
    func geometrySources() -> [SCNGeometrySource] { fatalError() }
    func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement? { fatalError() }
}

private class SemanticsImpl: Impl {
    let items: [Item]
    public init(_ ii: [Item]) {
        items = ii
    }
    override func geometrySources() -> [SCNGeometrySource] {
        items.map{ $0.geometrySource() }
    }
    override func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement? {
        items.first!.geometryElement(primitiveType: type)
    }
    
}

private class InterleaveImpl<T: Interleave> : Impl {
    private let array: [T]
    init(array aa: [T] ) {
        array = aa
    }
    override func geometrySources() -> [SCNGeometrySource] {
        array.geometrySources()
    }
    override func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement? {
        type == .lineStrip
        ? lineStripElement(count: array.count)
        : array.geometryElement(primitiveType: .init(type) )
    }
}

private class MetalInterleaveImpl<T: Interleave> : Impl {
    private let buffer: MTLBuffer
    init(of buffer: MTLBuffer ) {
        self.buffer = buffer
    }
    override func geometrySources() -> [SCNGeometrySource] {
        T.geometrySources(of: buffer)
    }
    override func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement? {
        type == .lineStrip
        ? lineStripElement(count: T.vertexCount(of: buffer))
        : T.geometryElement(from: buffer, primitiveType: .init(type))
    }
}



