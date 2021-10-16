import XCTest
@testable import SceneKit_util
import SceneKit

struct MyVertex {
    let position: SIMD2<Float>
    let texcoord: SIMD2<Float>
}

enum Semantics {
    case position
    case normal
    case texcoord
    case color
}

extension MyVertex {
        
    static func semantic<T>(_ v: T,_ keyPath: PartialKeyPath<Self>) -> some AttributeFormatTraits where T: BasicVertexDetail {
        Attrb<T>(.vertex, keyPath)
    }

}

extension MyVertex: Position, Texcoord, MetalInterleave {
    static var positionKeyPath: AttrbKeyPath { \Self.position }
    static var texcoordKeyPath: AttrbKeyPath { \Self.texcoord }
}

extension MyVertex: VertexInfo {
    
    static var vertexKeyPath: [ SCNGeometrySource.Semantic: PartialKeyPath<MyVertex> ] = [ .vertex: \Self.position, .texcoord: \Self.texcoord ]
    
    
//    static var vertexInfo: InterleaveInfo { [ .vertex: \.position, .texcoord: \.texcoord ] }
    static let hogehoge //: [ SCNGeometrySource.Semantic: (,PartialKeyPath<MyVertex>) ]
    : [SCNGeometrySource.Semantic: AttributeFormatTraits]
    = [  .vertex: semantic( SIMD2<Float>.zero, \Self.position ),
         .texcoord: Attrb<SIMD2<Float>>(.texcoord,\Self.texcoord) ]
    
    static let b: [SCNGeometrySource.Semantic:MTLVertexFormat]
    = [.vertex: .float, .texcoord: .float3]
    
//    static let test: A = D<Int>(\Self.position)
}


protocol VertexInfo {
    typealias InterleaveInfo = [ SCNGeometrySource.Semantic: PartialKeyPath<Self> ]
    static var vertexInfo: InterleaveInfo { get }
    var position: SIMD2<Float> { get }
    var texcoord: SIMD2<Float> { get }
}

extension VertexInfo {
    static var vertexInfo: InterleaveInfo { [ .vertex: \.position, .texcoord: \.texcoord ] }
    static func hoge() -> Int {
        MemoryLayout.offset(of: vertexInfo[.texcoord]!)!
    }
}


struct HalfVertex {
    let position: SIMD3<Float16>
    let normal: SIMD3<Float16>
}

extension HalfVertex: BasicInterleave, MetalInterleave {
    public static var basicAttributes: [BasicAttribute] {
        [ BasicAttrb( .vertex, \Self.position, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: 2 ),
          BasicAttrb( .normal, \Self.normal,   usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: 2 ) ]
    }
    public static var metalAttributes: [MetalAttribute] {
        [ MetalAttrb( .vertex, .half3, \Self.position ),
          MetalAttrb( .normal, .half3, \Self.normal ) ]
    }
}

let test_v: SIMD3<Float16> = .zero

//struct HalfVertex2: Position, Normal {
//    let position: SIMD3<UInt16>
//    let normal: SIMD3<UInt16>
//}
//extension HalfVertex2 {
//    static var positionKeyPath: PartialKeyPath<Self> { \Self.position }
//    static var normalKeyPath: PartialKeyPath<Self> { \Self.normal }
//}

extension Array where Element == MyVertex {
    init(_ seed:[((Float,Float),(Float,Float))] ) {
        self.init(seed.map{ .init(position: .init($0.0,$0.1), texcoord: .init($1.0,$1.0)) })
    }
}

struct vertex_n3h_v3h {
    var position: SIMD3<Float16> // Metal
    var normal: SIMD3<Float16> // Metal
}

extension vertex_n3h_v3h: MetalInterleave {
    public static var metalAttributes: [MetalAttribute] {
        [ VertexAttrib( .vertex, .half3, \Self.position ),
          VertexAttrib( .normal, .half3, \Self.normal   ) ]
    }
}

struct vertex_t2f_v3f {
    var position: SIMD3<Float> // Full
    var texcoord: SIMD2<Float> // Full
}

extension vertex_t2f_v3f: BasicInterleave, Position, Texcoord {
    static let positionKeyPath: AttrbKeyPath = \Self.position
    static let texcoordKeyPath: AttrbKeyPath = \Self.texcoord
}

// let a = vertex_t2f_v3f.attributeDetails
// let a = vertex_t2f_v3f.metalAttributeDetails

#if false
// 混在はMetalInterleaveにできなくしたい。これは、できない。
struct vertex_t2f_v2d: Position, Texcoord, MetalInterleave {
    var position: CGPoint // Full
    var texcoord: SIMD2<Float> // Basic
}

extension vertex_t2f_v2d {
    static let positionKeyPath: AttrbKeyPath = \Self.position
    static let texcoordKeyPath: AttrbKeyPath = \Self.texcoord
}
#endif

#if true
// 混在はMetalInterleaveにできなくしたいが、ポイントが適用されていると、できてしまう。
struct vertex_t2d_v3f: Position, Texcoord {
    var position: SIMD3<Float> // Full
    var texcoord: CGPoint // Basic
}
extension vertex_t2d_v3f {
    static let positionKeyPath: AttrbKeyPath = \Self.position
    static let texcoordKeyPath: AttrbKeyPath = \Self.texcoord
}
#endif

struct vertex_t2d_v3d: Position, Texcoord {
    var position: SCNVector3 // Basic
    var texcoord: CGPoint // Basic
}

extension vertex_t2d_v3d {
    static let positionKeyPath: AttrbKeyPath = \Self.position
    static let texcoordKeyPath: AttrbKeyPath = \Self.texcoord
}

//extension Array where Element: VectorDetail {
//    static var usesFloatComponentsT: Bool { __usesFloatComponents(Element.self) }
//}


final class SceneKit_utilTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            return
        }
        
        let vertices0: [MyVertex] = .init( [
                ( (0, 0), (0, 0) ),
                ( (1, 0), (1, 0) ),
                ( (1, 1), (1, 1) ),
                ( (0, 1), (0, 1) )
            ] )
        
//        let geometries = [
//            vertices0.geometry(with: device, primitiveType: .triangleStrip),
//            vertices0.geometry(with: device, primitiveType: .line),
//            vertices0.geometry(with: device, primitiveType: .point)]
        
//        XCTAssertEqual( KeyPathGet.hoge(MyVertex(position: .zero, texcoord: .zero)), 4)
        
    }
    
    func test0() throws {
        let vertex: [SIMD3<Float>] = []
        let normal: [SIMD3<Float>] = []
        let color: [SIMD3<Float>] = []

        let _ = Separated(arrays: [.vertex(vertex), .normal(normal), .color(color)])
            .geometry(primitiveType: .lineStrip)
    }
    
    func test1() throws {
        XCTAssertEqual( Int8.bytesPerComponent, 1 )
        XCTAssertEqual( Int16.bytesPerComponent, 2 )
        XCTAssertEqual( Int32.bytesPerComponent, 4 )
        XCTAssertEqual( Int.bytesPerComponent, 8 )
        XCTAssertEqual( SIMD3<Int>.bytesPerComponent, 8 )
    }
    
    func testSIMD() throws {
        
//        XCTAssertEqual( SCNGeometry.lineStripIndices(count: 4), [0,1,1,2,2,3])
//        
        XCTAssertEqual( SIMD2<Int16>.usesFloatComponents, false )
        XCTAssertEqual( SIMD2<Int16>.componentsPerVector, 2 )
        XCTAssertEqual( SIMD2<Int16>.bytesPerComponent, 2 )
        
        XCTAssertEqual( SIMD3<Int32>.usesFloatComponents, false )
        XCTAssertEqual( SIMD3<Int32>.componentsPerVector, 3 )
        XCTAssertEqual( SIMD3<Int32>.bytesPerComponent, 4 )
        
        XCTAssertEqual( SIMD3<Float>.usesFloatComponents, true )
        XCTAssertEqual( SIMD3<Float>.componentsPerVector, 3 )
        XCTAssertEqual( SIMD3<Float>.bytesPerComponent, 4 )
        
        XCTAssertEqual( SIMD4<Double>.usesFloatComponents, true )
        XCTAssertEqual( SIMD4<Double>.componentsPerVector, 4 )
        XCTAssertEqual( SIMD4<Double>.bytesPerComponent, 8 )

        XCTAssertEqual( SCNVector3(1,2,3) + SCNVector3(-1,-2,-3), SCNVector3(0,0,0) )
        XCTAssertEqual( SCNVector3(1,2,3) - SCNVector3(1,2,3), SCNVector3(0,0,0) )

        XCTAssertEqual( SCNVector4(1,2,3,4) + SCNVector4(-1,-2,-3,-4), SCNVector4(0,0,0,0) )
        XCTAssertEqual( SCNVector4(1,2,3,4) - SCNVector4(1,2,3,4), SCNVector4(0,0,0,0) )

        XCTAssertEqual( SCNVector3(1,2,3)[0], 1)
        XCTAssertEqual( SCNVector3(1,2,3)[1], 2)
        XCTAssertEqual( SCNVector3(1,2,3)[2], 3)

        XCTAssertEqual( SCNVector4(1,2,3,4)[0], 1)
        XCTAssertEqual( SCNVector4(1,2,3,4)[1], 2)
        XCTAssertEqual( SCNVector4(1,2,3,4)[2], 3)
        XCTAssertEqual( SCNVector4(1,2,3,4)[3], 4)

    }
    
}


