# SceneKit-util

Easily assemble SCN Geometry from Array or MTL Buffer.

## Features

|Features|
|-|
|Open source library written in Swift 5.5|
|Distribution with Swift Package|
|For rapid prototyping with SceneKit|


## How to use?

### 1. Prepare Vertex

``` Metal
typedef struct {
    vector_float3 texcoord;
    vector_float3 position;
} Vertex;
```

### 2. Adding Protocol Conformance

#### case 1

``` Swift
extension Vertex: Position, Texcoord, BasicInterleave
{
    static var positionKeyPath: PartialKeyPath<Self> { \Self.position }
    static var texcoordKeyPath: PartialKeyPath<Self> { \Self.texcoord }
}
```

#### case 2

``` Swift
extension Vertex: MetalInterleave
{
    public static var metalAttributes: [MetalAttribute]
    {
        [ Attrb< SIMD3<Float> >( .vertex, \Self.position ),
          Attrb< SIMD3<Float> >( .normal, \Self.normal   ) ]
    }
}
```

#### case 3

``` Swift
extension Vertex: BasicInterleave, MetalInterleave
{
    public static var basicAttributes: [BasicAttribute]
    {
        metalAttributeDetails
    }
    public static var metalAttributes: [MetalAttribute]
    {
        [ MetalAttrb( .vertex, .float3, \Self.position ),
          MetalAttrb( .normal, .float3, \Self.normal   ) ]
    }
}
```

### 3. Create SCNGeometry

#### Interleaved (1)
 - BasicInterleave protocol

``` Swift
let array: [Vertex] = ...
let geometry: SCNGeometry = Interleaved(array: array)
                                .geometry(primitiveType: .point)
```

``` Swift
let array: [Vertex] = ...
let geometry: SCNGeometry = Interleaved(array: array)
                                .geometry(elements: [(elementBuffer, .line)])
```

#### Interleaved (2)
 - MetalInterleave protocol

``` Swift
let vertexBuffer: MTLBuffer = ...
let geometry: SCNGeometry = Interleaved<Vertex>(buffer: vertexBuffer)
                                .geometry(primitiveType: .triangle)
```

``` Swift
let elementBuffer: MTLBuffer = ...
let vertexBuffer: MTLBuffer = ...
let geometry: SCNGeometry = Interleaved<Vertex>(buffer: vertexBuffer)
                                .geometry(elements: [(elementBuffer, .triangleStrip)])
```

#### Separated
- Arrays

``` Swift
let vertex: [SIMD3<Float>] = ...
let normal: [SIMD3<Float>] = ...
let geometry: SCNGeometry = Seprated(vertex: vertex, normal: normal)
                                .geometry(primitiveType: .lineStrip) // !!
```

``` Swift
let vertex: [SIMD3<Float>] = ...
let normal: [SIMD3<Float>] = ...
let geometry: SCNGeometry = Seprated(vertex: vertex, normal: normal)
                                .geometry(elements: [(elementBuffer, .triangle)])
```

## Requirements

- Xcode 13
- macOS11 or newer, iOS14 or newer

## Todo

- 違う名称にする
- ヘッダードックの追記
- ドキュメントもっと書く
- テストコード書く

