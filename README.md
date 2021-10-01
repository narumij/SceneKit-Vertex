# SceneKit-util

## 説明

配列やMTLBufferからSCNGeometryを生成します。

## 使い方

## 準備

``` Metal
typedef struct {
    vector_float3 texcoord;
    vector_float3 position;
} Vertex;
```

上記のようなMetalAPIで書かれた頂点構造体がある場合は、プロトコル適合することで利用可能になります。

例1
``` Swift
extension Vertex: Position, Texcoord {
    static var positionKeyPath: PartialKeyPath<Self> { \Self.position }
    static var texcoordKeyPath: PartialKeyPath<Self> { \Self.texcoord }
}
```

セマンティックに用いているメンバ名が、この拡張の想定と一致する場合、該当するセマンティックプロトコルに適合させます。
適合には、追加でメモリのオフセットを計算するために必要なクラスメンバ変数が必要になります。
セマンティックは今のところ、Position、Normal、Texcoord、Colorの4種類です。

例2
``` Swift
extension Vertex: Semantic {
    static var semanticDetail: [SemanticDetail] {
        [ (.vertex, .float3, MemoryLayout.offset(of: \Self.position)! ),
          (.texcoord, .float3, MemoryLayout.offset(of: \Self.normal)! ) ]
    }
}
```

半精度浮動小数や、normalizedな整数を用いたい場合、あるいはセマンティック名として想定している名前とは違うメンバ名を構造体に採用したい場合。こちらの方法で利用できます。


## 使用例

例1
``` Swift
let vertexBuffer: MTLBuffer = ...
let geometry = Interleaved<Vertex>(buffer: vertexBuffer)
                   .geometry(primitiveType: .point)
```

例2
``` Swift
let elementBuffer: MTLBuffer = ...
let vertexBuffer: MTLBuffer = ...
let geometry = Interleaved<Vertex>(buffer: vertexBuffer)
                   .geometry(elements: [(elementBuffer, .point)])
```

例3
``` Swift
let array: [Vertex] = ...
let geometry = Interleaved(array: array)
                   .geometry(primitiveType: .point)
```

例4
``` Swift
let vertex: [SIMD3<Float>] = ...
let normal: [SIMD3<Float>] = ...
let geometry = Seprated(vertex: vertex, normal: normal)
                   .geometry(primitiveType: .lineStrip)
```

## いつかやる

- ヘッダードックの追記
- ドキュメントの英語化
- テストコードの追加
