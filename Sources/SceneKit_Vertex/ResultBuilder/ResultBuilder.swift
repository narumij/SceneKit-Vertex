//
//  Created by narumij on 2023/06/14.
//

import SceneKit

public protocol StandardAttributeProvider {
    
    func geometrySource(semantic: SCNGeometrySource.Semantic) -> [SCNGeometrySource]
}

public protocol ExtendedAttributeProvider {
    
    func geometrySource(semantic: SCNGeometrySource.Semantic, vertexFormat: MTLVertexFormat) -> [SCNGeometrySource]
}

extension Array:       StandardAttributeProvider where Vertex: ComponentType { }
extension TypedData:   StandardAttributeProvider where Vertex: ComponentType { }
extension TypedBuffer: StandardAttributeProvider where Vertex: VertexFormatType { }
extension TypedBuffer: ExtendedAttributeProvider where Vertex: VertexFormatType { }

// MARK: -

public protocol InterleaveProvider {
    
    func geometrySources() -> [SCNGeometrySource]
}

extension Array:       InterleaveProvider where Vertex: InterleavedVertex { }
extension TypedData:   InterleaveProvider where Vertex: InterleavedVertex { }
extension TypedBuffer: InterleaveProvider where Vertex: InterleavedVertex { }

// MARK: -

public protocol ElementArrayProvider {
    func geometryElements(primitiveType: SCNGeometryPrimitiveType) -> SCNGeometryElement
}

public protocol ElementDataProvider {
    func geometryElements(primitiveType: SCNGeometryPrimitiveType) -> SCNGeometryElement
}

@available(macOS 12.0, iOS 14.0, tvOS 14.0, *)
public protocol ElementBufferProvider {
    func geometryElements(primitiveType: SCNGeometryPrimitiveType) -> SCNGeometryElement
}

public protocol PolygonArrayProvider {
    func polygonGeometryElements() -> SCNGeometryElement
}

extension Array:       ElementArrayProvider  where Element: FixedWidthInteger { }
extension TypedData:   ElementDataProvider   where Element: FixedWidthInteger { }
extension TypedBuffer: ElementBufferProvider where Element: FixedWidthInteger { }
extension Array:       PolygonArrayProvider  where Element: PolygonElement { }

// MARK: -

public struct SourceItem {

    public init(separate: StandardAttributeProvider, semantic: SCNGeometrySource.Semantic) {
        self.sources = separate.geometrySource(semantic: semantic)
    }

    public init(separate: ExtendedAttributeProvider, semantic: SCNGeometrySource.Semantic, vertexFormat: MTLVertexFormat) {
        self.sources = separate.geometrySource(semantic: semantic, vertexFormat: vertexFormat)
    }

    public init(interleave: InterleaveProvider) {
        self.sources = interleave.geometrySources()
    }
    
    init(vertices: [SCNVector3]) {
        self.sources = [SCNGeometrySource(vertices: vertices)]
    }

    init(_ source: SCNGeometrySource) {
        self.sources = [source]
    }
    
    public init(sources: [SCNGeometrySource]) {
        self.sources = sources
    }

    var sources: [SCNGeometrySource]
}

public struct ElementItem {

    public init(element: ElementArrayProvider, primitiveType: SCNGeometryPrimitiveType) {
        self.elements = [element.geometryElements(primitiveType: primitiveType)]
    }
    
    public init(element: ElementDataProvider, primitiveType: SCNGeometryPrimitiveType) {
        self.elements = [element.geometryElements(primitiveType: primitiveType)]
    }

    @available(macOS 12.0, iOS 14.0, tvOS 14.0, *)
    public init(element: ElementBufferProvider, primitiveType: SCNGeometryPrimitiveType) {
        self.elements = [element.geometryElements(primitiveType: primitiveType)]
    }

    public init(polygonElement: PolygonArrayProvider) {
        self.elements = [polygonElement.polygonGeometryElements()]
    }

    init(_ element: SCNGeometryElement) {
        self.elements = [element]
    }
    
    public init(elements: [SCNGeometryElement]) {
        self.elements = elements
    }

    var elements: [SCNGeometryElement]
}

// MARK: -

@resultBuilder
public enum GeometryBuilder {
    public typealias Source = SourceItem
    public typealias Element = ElementItem
    case sources(Source)
    case element(Element)
}

extension GeometryBuilder {
    
    public var geometrySources: [SCNGeometrySource] {
        switch self {
        case .sources(let s): s.sources
        case .element: []
        }
    }

    public var geometryElements: [SCNGeometryElement] {
        switch self {
        case .element(let e): e.elements
        case .sources: []
        }
    }
}

public extension GeometryBuilder {
    
    // 配列の直接配置を位置ベクトルの配列として扱う
    static func buildExpression<T: ComponentType>(_ expression: [T]) -> [GeometryBuilder] {
        [.sources(Source(separate: expression, semantic: .vertex))]
    }

    // インターリーブ配列の直接配置を、ソース配列として扱う（はず）
    static func buildExpression<T: InterleavedVertex>(_ expression: [T]) -> [GeometryBuilder] {
        [.sources(Source(interleave: expression))]
    }

    static func buildExpression(_ expression: [SCNVector3]) -> [GeometryBuilder] {
        [.sources(Source(vertices: expression))]
    }

    static func buildExpression(_ expression: SCNGeometrySource) -> [GeometryBuilder] {
        [.sources(Source(expression))]
    }
    
    static func buildExpression(_ expression: SCNGeometryElement) -> [GeometryBuilder] {
        [.element(Element(expression))]
    }

    static func buildExpression(_ expression: Source) -> [GeometryBuilder] {
        [.sources(expression)]
    }
    
    static func buildExpression(_ expression: Element) -> [GeometryBuilder] {
        [.element(expression)]
    }
}

public extension GeometryBuilder {
    
    static func buildBlock(_ components: [GeometryBuilder]...) -> [GeometryBuilder] {
        components.flatMap{ $0 }
    }

    static func buildOptional(_ component: [GeometryBuilder]?) -> [GeometryBuilder] {
        component ?? []
    }

    static func buildExpression(_ expression: Void) -> [GeometryBuilder] {
        []
    }
    
    static func buildEither(first component: [GeometryBuilder]) -> [GeometryBuilder] {
        component
    }

    static func buildEither(second component: [GeometryBuilder]) -> [GeometryBuilder] {
        component
    }
    
    static func buildArray(_ components: [[GeometryBuilder]]) -> [GeometryBuilder] {
        components.flatMap{ $0 }
    }
    
    static func buildLimitedAvailability(_ component: [GeometryBuilder]) -> [GeometryBuilder] {
        component
    }
    
    static func buildFinalResult(_ component: [GeometryBuilder]) -> (sources:[SCNGeometrySource], elements:[SCNGeometryElement]) {
        
        (component.flatMap { $0.geometrySources }, component.flatMap { $0.geometryElements })
    }
}

// MARK: -

@resultBuilder
public enum GeometrySourceBuilder {
    public typealias Source = GeometryBuilder.Source
    case sources(Source)
}

extension GeometrySourceBuilder {
    
    public var geometrySources: [SCNGeometrySource] {
        switch self {
        case .sources(let s): s.sources
        }
    }
}

public extension GeometrySourceBuilder {
    
    // 配列の直接配置を位置ベクトルの配列として扱う
    static func buildExpression<T: ComponentType>(_ expression: [T]) -> [GeometrySourceBuilder] {
        [.sources(Source(separate: expression, semantic: .vertex))]
    }

    // インターリーブ配列の直接配置を、ソース配列として扱う（はず）
    static func buildExpression<T: InterleavedVertex>(_ expression: [T]) -> [GeometrySourceBuilder] {
        [.sources(Source(interleave: expression))]
    }
    
    // SCNVector3の配列を位置ベクトルの配列として扱う
    static func buildExpression(_ expression: [SCNVector3]) -> [GeometrySourceBuilder] {
        [.sources(Source(vertices: expression))]
    }
    
    // SCNGeometrySourceを直接扱う
    static func buildExpression(_ expression: SCNGeometrySource) -> [GeometrySourceBuilder] {
        [.sources(Source(expression))]
    }
    
    // Sourceを扱う
    static func buildExpression(_ expression: Source) -> [GeometrySourceBuilder] {
        [.sources(expression)]
    }
}

public extension GeometrySourceBuilder {

    static func buildBlock(_ components: [GeometrySourceBuilder]...) -> [GeometrySourceBuilder] {
        components.flatMap{ $0 }
    }

    static func buildOptional(_ component: [GeometrySourceBuilder]?) -> [GeometrySourceBuilder] {
        component ?? []
    }

    static func buildExpression(_ expression: Void) -> [GeometrySourceBuilder] {
        []
    }

    static func buildEither(first component: [GeometrySourceBuilder]) -> [GeometrySourceBuilder] {
        component
    }

    static func buildEither(second component: [GeometrySourceBuilder]) -> [GeometrySourceBuilder] {
        component
    }
    
    static func buildArray(_ components: [[GeometrySourceBuilder]]) -> [GeometrySourceBuilder] {
        components.flatMap{ $0 }
    }
    
    static func buildLimitedAvailability(_ component: [GeometrySourceBuilder]) -> [GeometrySourceBuilder] {
        component
    }
    
    static func buildFinalResult(_ component: [GeometrySourceBuilder]) -> [SCNGeometrySource] {
        component.flatMap{ $0.geometrySources }
    }
}
