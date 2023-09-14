//
//  SCNVertexTests.swift
//  
//
//  Created by narumij on 2023/08/13.
//

import XCTest
import SceneKit
@testable import SceneKit_Vertex

// TODO: スモークテストしかできていないのを解消する。(XCTAssertEqualがエラーにならなくなったら）

final class SCNVertexTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        XCTAssertEqual(8, MemoryLayout<Int>.stride)
    }
    
    func testCase1() throws {
        
        let geometry0: SCNGeometry = SCNGeometry(primitiveType: .line) {
            [[0,0,0], [1,1,1]] as [SIMD3<Float>]
        }

        let geometry1: SCNGeometry = SCNGeometry() {
            #vertex<SIMD3<Float>>([[0,0,0], [1,1,1]])
            #elements<UInt32>(primitiveType: .line, [0, 1])
        }
        
        let geom = SCNGeometry(primitiveType: .triangleStrip) {
            #vertex<SIMD3<Float>>([[-1,-1, 0], [ 1,-1, 0], [-1, 1, 0], [ 1, 1, 0]])
            #color<SIMD3<Float>>([[0,0,0], [1,0,0], [0,1,0], [1,1,0]])
        }
        
#if false
        XCTAssertEqual(1, geometry0.sources.count)
        XCTAssertEqual(1, geometry0.elements.count)
        XCTAssertEqual(.vertex, geometry0.sources.first?.semantic)
        XCTAssertEqual(.line, geometry0.elements.first?.primitiveType)

        XCTAssertEqual(1, geometry1.sources.count)
        XCTAssertEqual(1, geometry1.elements.count)
        XCTAssertEqual(.vertex, geometry1.sources.first?.semantic)
        XCTAssertEqual(.line, geometry1.elements.first?.primitiveType)

        XCTAssertEqual(2, geom.sources.count)
        XCTAssertEqual(1, geom.elements.count)
        XCTAssertEqual(.vertex, geom.sources[0].semantic)
        XCTAssertEqual(.color, geom.sources[1].semantic)
        XCTAssertEqual(.triangleStrip, geometry1.elements.first?.primitiveType)
#else
        XCTAssert(2 == geom.sources.count)
        XCTAssert(1 == geom.elements.count)
        XCTAssert(.vertex == geom.sources[0].semantic)
        XCTAssert(.color == geom.sources[1].semantic)
        XCTAssert(.triangleStrip == geom.elements.first?.primitiveType)
#endif
    }
    
    @SCNVertex struct InterleavedVertex {
        var position: SIMD3<Float>
        var normal: SIMD2<Float>
    }

    func testCase2() throws {

        let vertices: [InterleavedVertex] = [
            .init(position: [0,0,0], normal: [0,0]),
            .init(position: [1,1,1], normal: [1,1])]

        let geometry0: SCNGeometry = SCNGeometry(primitiveType: .line) {
            vertices
        }

        let geometry1: SCNGeometry = SCNGeometry() {
            #interleave(vertices)
            #elements<UInt32>(primitiveType: .line, [0,1])
        }
        
#if false
        XCTAssertEqual(2, geometry0.sources.count)
        XCTAssertEqual(1, geometry0.elements.count)
        XCTAssertEqual(.vertex, geometry1.sources[0].semantic)
        XCTAssertEqual(.normal, geometry1.sources[0].semantic)

        XCTAssertEqual(2, geometry1.sources.count)
        XCTAssertEqual(1, geometry1.elements.count)
        XCTAssertEqual(.vertex, geometry1.sources[0].semantic)
        XCTAssertEqual(.normal, geometry1.sources[0].semantic)
#else
        throw XCTSkip("compiler bug?")
#endif
    }
    
    struct MetalVertex {
        var texcoord: SIMD3<Float>
        var position: SIMD3<UInt16>
        var nameless: SIMD2<Float>
    };

    @SCNVertex struct Vertex_N3FV3F {
        var normal: SIMD3<Float>
        var vertex: SIMD3<UInt16>
    }
    
    func testCase3() throws {
        
        var device = MTLCreateSystemDefaultDevice()!
        
        var vertices: [Vertex_N3FV3F] = [
            .init(normal: .zero, vertex: .zero),
            .init(normal: .zero, vertex: .zero),
            .init(normal: .zero, vertex: .zero),
        ]
        
        var buffer = vertices.buffer(device: device)
        
        try case3(vertexBuffer: buffer!)
    }
    
    func case3(vertexBuffer: MTLBuffer) throws {
        
        let geometry1: SCNGeometry = SCNGeometry(primitiveType: .triangles) {
            #interleave<MetalVertex>(buffer: vertexBuffer)
        }
        
        let geometry2: SCNGeometry = SCNGeometry {
            #interleave<MetalVertex>(buffer: vertexBuffer)
            #elements<Int32>(primitiveType: .line, [0,4,1,3,2])
        }
        
        let geometry3: SCNGeometry = SCNGeometry {
            #interleave<Vertex_N3FV3F>(buffer: vertexBuffer)
            #elements<Int32>(primitiveType: .line, buffer: vertexBuffer)
        }
    }
    
#if !os(macOS)
    struct BasicVertex2 {
        var position: SCNVector4
        var normal: SCNVector3
        var nameless: Int32
        var texcoord: Float
    };

    func testCase4_2() throws {
        
        XCTAssert(Float.self == SCNFloat.self)
        
        let vertices: [BasicVertex2] = [
            .init(position: .init(0, 0, 0, 1), normal: .init(0, 0, 0), nameless: 0, texcoord: 0),
            .init(position: .init(0, 0, 0, 1), normal: .init(0, 0, 0), nameless: 0, texcoord: 0),
            .init(position: .init(0, 0, 0, 1), normal: .init(0, 0, 0), nameless: 0, texcoord: 0)
        ]
        
        let geometry0: SCNGeometry = SCNGeometry(primitiveType: .triangles) {
            #interleave(vertices)
        }

        let geometry1: SCNGeometry = SCNGeometry() {
            #interleave(vertices)
            #element<Int>(primitiveType: .triangles, [0,1,2])
        }
    }
#endif

    func testCase4() throws {
        
        let positions: [SCNVector3] = [SCNVector3(0,0,0),SCNVector3(0,1,0),SCNVector3(1,1,0),SCNVector3(1,0,0)]
        
        // elementを用意しない場合、一枚しか取り扱えない
        let geometry1 = SCNGeometry(primitiveType: .polygon) {
            
            SCNGeometrySource(normals: [])
            SCNGeometrySource(vertices: [])
            SCNGeometrySource(textureCoordinates: [])
            
            SCNGeometrySource(vertices: positions)
            #position(positions)
        }
    }
    
    func testCase5() throws {
        
        let positions: [SCNVector3] = [SCNVector3(0,0,0),SCNVector3(0,1,0),SCNVector3(1,1,0),SCNVector3(1,0,0)]
        let elements: [[UInt32]] = [[0,1,2,3],[3,2,1,0]]
        
        let geometry0: SCNGeometry = SCNGeometry(primitiveType: .line) {
            positions
        }

        // elementを用意することで、複数枚取り扱える
        let geometry1 = SCNGeometry {
            #position(positions)
            #polygon(elements)
            #elements<UInt32>(primitiveType: .polygon, [0,1,2,3])
        }
    }
    
    func testOtherCase1() throws {
        
        let device = MTLCreateSystemDefaultDevice()!
        
        let indices: [UInt32] = [0,1,2]
        
        let buffer = indices.buffer(device: device)
        
        try otherCase1(elementBuffer: buffer!)
    }
    
    func otherCase1(elementBuffer: MTLBuffer) throws {
        
        let vertex: [SIMD3<Float>] = []
        let normal: [SIMD3<Float>] = []

        let geometry: SCNGeometry = SCNGeometry() {
            #vertex(vertex)
            #normal(normal)
            #elements<UInt32>(primitiveType: .triangles, buffer: elementBuffer)
        }
        
#if !os(macOS)
        let geom = SCNGeometry(primitiveType: .point) {
            #interleave<BasicVertex2>(buffer: elementBuffer)
        }
#endif
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension SCNVertexTests.MetalVertex: InterleavedVertex {
    
    static var interleave: [InterleaveAttribute] = [
        #texcoord,
        #position(),
        #position(vertexFormat: .half3),
        #position(keyPath: \Self.nameless, vertexFormat: .half3),
        #position(keyPath: \Self.nameless),
        #normal(keyPath: \Self.nameless, vertexFormat: .float2),
    ]
}

#if !os(macOS)
extension SCNVertexTests.BasicVertex2: InterleavedVertex {
    
    static var interleave: [InterleaveAttribute] = [
        #position,
        #normal,
        InterleaveAttribute(keyPath: \Self.texcoord, semantic: .texcoord),
        InterleaveAttribute(keyPath: \Self.nameless, semantic: .tangent)
    ]
}
#endif
