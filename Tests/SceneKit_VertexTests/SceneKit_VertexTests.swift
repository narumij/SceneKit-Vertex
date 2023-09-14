import XCTest
@testable import SceneKit_Vertex
import SceneKit

#if true
@SCNVertex struct MyVertex {
    let position: SIMD2<Float>
    let texcoord: SIMD2<Float>
}

extension Array where Element == MyVertex {
    init(_ seed:[((Float,Float),(Float,Float))] ) {
        self.init(seed.map{ .init(position: .init($0.0,$0.1), texcoord: .init($1.0,$1.0)) })
    }
}

@SCNVertex struct vertex_t2f_v3f {
    var position: SIMD3<Float> // Full
    var texcoord: SIMD2<Float> // Full
}
#endif

#if false
struct vertex_v3h {
    var position: SIMD3<Float16>
}
#endif

#if true
@SCNVertex struct vertex_v3us {
    @SCNAttribute(vertexFormat: .half3) var position: SIMD3<UInt16>
}

@SCNVertex struct ijk {
    @SCNAttribute(semantic: .vertex) var ijk: SIMD3<UInt16>
    @SCNIgnore var something: Any
}
#endif

#if false
// 混在はMetalInterleaveにできなくしたい。これは、できない。
@MTLVertex struct vertex_t2f_v2d: MetalInterleaveProtocol {
    var ijk: CGPoint // Full
    var texcoord: SIMD2<Float> // Basic
}
#endif

#if false
// 混在はMetalInterleaveにできなくしたいが、ポイントが適用されていると、できてしまう。
@MTLVertex struct vertex_t2d_v3f {
    var ijk: SIMD3<Float> // Full
    var texcoord: CGPoint // Basic
}
#endif

#if false
@MTLVertex struct vertex_t2d_v3d {
    var position: SCNVector3 // Basic
    var texcoord: CGPoint // Basic
}
#endif

final class SceneKit_VertexTests: XCTestCase {
    
#if true
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
//        guard let device = MTLCreateSystemDefaultDevice() else {
//            return
//        }
        
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
        
//        XCTAssertEqual(8,
//                       MemoryLayout.offset(of: texcoordKeyPath(MyVertex.self) ) )

//        XCTAssertEqual(8,
//                       MemoryLayout.offset(of: MyVertex.texcoordKeyPath ) )
//
//        XCTAssertEqual(8,
//                       MemoryLayout.offset(of: \MyVertex.texcoord ) )
//
//        XCTAssertEqual(MyVertex.texcoordKeyPath, \MyVertex.texcoord)
//        XCTAssertEqual(texcoordKeyPath(MyVertex.self), \MyVertex.texcoord)
    }
#endif
    
    func test0() throws {
        let vertex: [SIMD3<Float>] = []
        let normal: [SIMD3<Float>] = []
        let color: [SIMD3<Float>] = []

//        let _ = Separated(arrays: [.vertex(vertex), .normal(normal), .color(color)])
//            .geometry(primitiveType: .lineStrip)
        let _ = SCNGeometry(primitiveType: .line) {
            #vertex(vertex)
            #normal(normal)
            #color(color)
        }
    }
    
    func test1() throws {
        XCTAssertEqual( Int8.bytesPerComponent, 1 )
        XCTAssertEqual( Int16.bytesPerComponent, 2 )
        XCTAssertEqual( Int32.bytesPerComponent, 4 )
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
        

    }
    
    func testHoge() throws {
        
        let device = MTLCreateSystemDefaultDevice()!
        
        let vertices: [vertex_v3us] = [.init(position: .zero)]
        
        let buffer = vertices.buffer(device: device)
        
        try hoge(buffer: buffer!)
    }
    
    func hoge(buffer: MTLBuffer) throws {
        
        #interleave<vertex_v3us>(buffer: buffer)
        #interleave<vertex_v3us>(buffer: buffer, count: 3)

        #elements<Int32>(primitiveType: .line, [0,4,1,3,2])

        #elements<UInt32>(primitiveType: .triangles, buffer: buffer)
        #elements<UInt32>(primitiveType: .triangles, buffer: buffer, count: 3)
    }
    
    func testAttrbInfo() throws {
        
        struct V { var position: SIMD3<Float> }
        struct VV { var position: SIMD3<Float>; var normal: SIMD2<Float> }

//        XCTAssertNotNil(Attrb(semantic: .vertex, keyPath: \V.position).keyPath as? AttributeKeyPath<V,SIMD3<Float>>)
//        XCTAssertNotNil(AttrbInfo(semantic: .vertex, keyPath: \VV.normal).keyPath as? AttributeKeyPath<VV,SIMD2<Float>>)
//        XCTAssertNil(AttrbInfo(semantic: .vertex, keyPath: \V.position).keyPath as? AttributeKeyPath<VV,SIMD3<Float>>)
//        XCTAssertNil(AttrbInfo(semantic: .normal, keyPath: \VV.normal).keyPath as? AttributeKeyPath<V,SIMD2<Float>>)
    }
    
    func testArray() throws {
        
        XCTAssertNil([Int]().data)
    }
}

