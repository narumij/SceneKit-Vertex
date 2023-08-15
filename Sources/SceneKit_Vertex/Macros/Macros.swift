import SceneKit
import Metal

// MARK: - 頂点定義向けマクロ

/// Interleaved vertex definition macro.
///
/// Usage:
/// ```swift
/// @SCNVertex struct Interleaved {
///     var position: SIMD3<Float>
///     var normal: SIMD3<Float>
/// }
/// ```
@attached(extension, conformances: InterleavedVertex, names: named(interleave))
public macro SCNVertex() = #externalMacro(module: "SCNVertexMacros", type: "SCNVertexMacro")

/// Interleaved vertex attribute macro.
///
/// Assigns to different named semantics and specifies the type.
///
/// Usage:
/// ```swift
/// @SCNAttribute(semantic: .normal, vertexFormat: ushort3Normalized) var n: SIMD3<UInt16>
/// ```
@attached(peer)
public macro SCNAttribute(semantic: SCNGeometrySource.Semantic, vertexFormat: MTLVertexFormat) = #externalMacro(module: "SCNVertexMacros", type: "AttributeMacro")

/// Interleaved vertex attribute macro.
///
/// Assigns to different named semantics.
///
/// Usage:
/// ```swift
/// @SCNAttribute(semantic: .vertex) var p: SIMD3<Float>
/// ```
@attached(peer)
public macro SCNAttribute(semantic: SCNGeometrySource.Semantic) = #externalMacro(module: "SCNVertexMacros", type: "AttributeMacro")

/// Interleaved vertex attribute macro.
///
/// Adds type specification.
///
/// Usage:
/// ```swift
/// @SCNAttribute(vertexFormat: ushort3Normalized) var normal: SIMD3<UInt16>
/// ```
@attached(peer)
public macro SCNAttribute(vertexFormat: MTLVertexFormat) = #externalMacro(module: "SCNVertexMacros", type: "AttributeMacro")

/// Interleaved vertex exclusion macro.
///
/// Usage:
/// ```swift
/// @SCNIgnore var info: AnyObject
/// ```
@attached(peer)
public macro SCNIgnore() = #externalMacro(module: "SCNVertexMacros", type: "AttributeMacro")

// MARK: - 頂点のプロトコル適合向け

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #position
///     #position(vertexFormat: .float3)
///     #position(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #position(keyPath: \Self.someProperty)
/// }
/// ```
@freestanding(expression)
public macro position(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@freestanding(expression)
public macro position(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #vertex
///     #vertex(vertexFormat: .float3)
///     #vertex(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #vertex(keyPath: \Self.someProperty)
/// }
/// ```
@freestanding(expression)
public macro vertex(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@freestanding(expression)
public macro vertex(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #texcoord
///     #texcoord(vertexFormat: .float3)
///     #texcoord(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #texcoord(keyPath: \Self.someProperty)
/// }
/// ```
@freestanding(expression)
public macro texcoord(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@freestanding(expression)
public macro texcoord(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #normal
///     #normal(vertexFormat: .float3)
///     #normal(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #normal(keyPath: \Self.someProperty)
/// }
/// ```
@freestanding(expression)
public macro normal(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@freestanding(expression)
public macro normal(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #color
///     #color(vertexFormat: .float3)
///     #color(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #color(keyPath: \Self.someProperty)
/// }
/// ```
@freestanding(expression)
public macro color(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@freestanding(expression)
public macro color(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #tangent
///     #tangent(vertexFormat: .float3)
///     #tangent(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #tangent(keyPath: \Self.someProperty)
/// }
/// ```
@available(iOS 10.0, *)
@freestanding(expression)
public macro tangent(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@available(iOS 10.0, *)
@freestanding(expression)
public macro tangent(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #edgeCrease
///     #edgeCrease(vertexFormat: .float3)
///     #edgeCrease(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #edgeCrease(keyPath: \Self.someProperty)
/// }
/// ```
@freestanding(expression)
public macro edgeCrease(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@freestanding(expression)
public macro edgeCrease(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #vertexCrease
///     #vertexCrease(vertexFormat: .float3)
///     #vertexCrease(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #vertexCrease(keyPath: \Self.someProperty)
/// }
/// ```
@freestanding(expression)
public macro vertexCrease(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@freestanding(expression)
public macro vertexCrease(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #boneIndices
///     #boneIndices(vertexFormat: .float3)
///     #boneIndices(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #boneIndices(keyPath: \Self.someProperty)
/// }
/// ```
@freestanding(expression)
public macro boneIndices(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@freestanding(expression)
public macro boneIndices(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

/// Usage
/// ```swift
/// extension Vertex: MetalInterleave {
///     #boneWeights
///     #boneWeights(vertexFormat: .float3)
///     #boneWeights(keyPath: \Self.someProperty, vertexFormat:.float3)
///     #boneWeights(keyPath: \Self.someProperty)
/// }
/// ```
@freestanding(expression)
public macro boneWeights(vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

@freestanding(expression)
public macro boneWeights(keyPath: AnyKeyPath, vertexFormat: MTLVertexFormat? = nil) -> InterleaveAttribute = #externalMacro(module: "SCNVertexMacros", type: "InterleaveAttributeMacro")

// MARK: - ジオメトリ向け

@freestanding(expression)
public macro interleave<T: InterleavedVertex>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "InterleaveArrayMacro")

@freestanding(expression)
public macro interleave<T: InterleavedVertex>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "InterleaveDataMacro")

@freestanding(expression)
public macro interleave<T: InterleavedVertex>(buffer: MTLBuffer, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "InterleaveBufferMacro")


@freestanding(expression)
public macro element<T: FixedWidthInteger>(primitiveType: SCNGeometryPrimitiveType, _ item: [T]) -> GeometryBuilder.Element = #externalMacro(module: "SCNVertexMacros", type: "ElementArrayMacro")

@freestanding(expression)
public macro element<T: FixedWidthInteger>(primitiveType: SCNGeometryPrimitiveType, data: Data, count: Int? = nil) -> GeometryBuilder.Element = #externalMacro(module: "SCNVertexMacros", type: "ElementDataMacro")

@freestanding(expression)
public macro element<T: FixedWidthInteger>(primitiveType: SCNGeometryPrimitiveType, buffer: MTLBuffer, count: Int? = nil) -> GeometryBuilder.Element = #externalMacro(module: "SCNVertexMacros", type: "ElementBufferMacro")

// MARK: -

// elementに統合しない

@freestanding(expression)
public macro polygon<T: FixedWidthInteger>(_ item: [[T]]) -> GeometryBuilder.Element = #externalMacro(module: "SCNVertexMacros", type: "PolygonMacro")

// MARK: -

@freestanding(expression)
public macro position(_ item: [SCNVector3]) -> SCNGeometrySource = #externalMacro(module: "SCNVertexMacros", type: "SCNGeometrySourceVerticesMacro")

@freestanding(expression)
public macro position<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@freestanding(expression)
public macro position<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@freestanding(expression)
public macro position<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")

@freestanding(expression)
public macro vertex(_ item: [SCNVector3]) -> SCNGeometrySource = #externalMacro(module: "SCNVertexMacros", type: "SCNGeometrySourceVerticesMacro")

@freestanding(expression)
public macro vertex<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@freestanding(expression)
public macro vertex<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@freestanding(expression)
public macro vertex<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")

@freestanding(expression)
public macro texcoord(_ item: [CGPoint]) -> SCNGeometrySource = #externalMacro(module: "SCNVertexMacros", type: "SCNGeometrySourceTexcoordsMacro")

@freestanding(expression)
public macro texcoord<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@freestanding(expression)
public macro texcoord<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@freestanding(expression)
public macro texcoord<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")

@freestanding(expression)
public macro normal(_ item: [SCNVector3]) -> SCNGeometrySource = #externalMacro(module: "SCNVertexMacros", type: "SCNGeometrySourceTexcoordsMacro")

@freestanding(expression)
public macro normal<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@freestanding(expression)
public macro normal<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@freestanding(expression)
public macro normal<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")

@freestanding(expression)
public macro color<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@freestanding(expression)
public macro color<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@freestanding(expression)
public macro color<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")

@available(iOS 10.0, *)
@freestanding(expression)
public macro tangent<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@available(iOS 10.0, *)
@freestanding(expression)
public macro tangent<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@available(iOS 10.0, *)
@freestanding(expression)
public macro tangent<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")

@freestanding(expression)
public macro edgeCrease<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@freestanding(expression)
public macro edgeCrease<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@freestanding(expression)
public macro edgeCrease<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")

@freestanding(expression)
public macro vertexCrease<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@freestanding(expression)
public macro vertexCrease<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@freestanding(expression)
public macro vertexCrease<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")

@freestanding(expression)
public macro boneIndices<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@freestanding(expression)
public macro boneIndices<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@freestanding(expression)
public macro boneIndices<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")

@freestanding(expression)
public macro boneWeights<T>(_ item: [T]) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceArrayMacro")

@freestanding(expression)
public macro boneWeights<T: VertexFormatType>(data: Data, count: Int? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceDataMacro")

@freestanding(expression)
public macro boneWeights<T: VertexFormatType>(buffer: MTLBuffer, count: Int? = nil, vertexFormat: MTLVertexFormat? = nil) -> GeometryBuilder.Source = #externalMacro(module: "SCNVertexMacros", type: "SourceBufferMacro")
