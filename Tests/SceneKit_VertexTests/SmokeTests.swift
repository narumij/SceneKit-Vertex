//
//  SmokeTests.swift
//
//
//  Created by narumij on 2023/08/13.
//

import XCTest
import SceneKit
@testable import SceneKit_Vertex
import simd

final class SmokeTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    struct SmokeVertex {
        var float4: SIMD4<Float>
        var int4: SIMD3<Int32>
        var uint4: SIMD3<UInt32>
        var short4: SIMD3<Int16>
        var ushort4: SIMD3<UInt16>
        var char4: SIMD3<Int8>
        var uchar4: SIMD3<UInt8>
    }
    
    struct Dummy: DefaultVetexFormats {
        static var defaultVertexFotmats: [MTLVertexFormat] = [.float]
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let somkeVertex = SmokeVertex(float4: .zero, int4: .zero, uint4: .zero, short4: .zero, ushort4: .zero, char4: .zero, uchar4: .zero)
        
        let geom = SCNGeometry(primitiveType: .point) {
            #interleave([somkeVertex])
        }
        
        XCTAssertNotNil(geom)
    }
    
    func testTypedData1() throws {
        
        let somkeVertex = SmokeVertex(float4: .zero, int4: .zero, uint4: .zero, short4: .zero, ushort4: .zero, char4: .zero, uchar4: .zero)
        
        let geom = SCNGeometry(primitiveType: .point) {
            #interleave<SmokeVertex>(data:[somkeVertex].data!)
        }
        
        XCTAssertNotNil(geom)
    }
    
    func testTypedData2() throws {
        
        let geom = SCNGeometry {
            #position<SIMD3<Float>>(data:Data())
            #elements<UInt32>(primitiveType: .point, data:Data())
        }
        
        XCTAssertNotNil(geom)
    }
    
    func testTypedBuffer() throws {
        
        let device = MTLCreateSystemDefaultDevice()!
        
        let indices: [UInt32] = [0,1,2]
        
        let buffer = indices.buffer(device: device)
        
        try typedBuffer1(buffer: buffer!)
        try typedBuffer2(buffer: buffer!)
        
        XCTAssertEqual([0,1,2], TypedBuffer<UInt32>(buffer: buffer!).array)
    }
    
    func typedBuffer1(buffer: MTLBuffer) throws {
        
        let geom = SCNGeometry(primitiveType: .point) {
            #interleave<SmokeVertex>(buffer: buffer)
        }
        
        XCTAssertNotNil(geom)
    }
    
    func typedBuffer2(buffer: MTLBuffer) throws {
        
        let geom = SCNGeometry {
            #position<SIMD3<Int16>>(buffer: buffer, vertexFormat: .short3Normalized)
            #normal<SIMD3<Int16>>(buffer: buffer)
            #elements<UInt32>(primitiveType: .point, buffer: buffer)
        }
        
        XCTAssertNotNil(geom)
    }
    
    
    func testSmoke1() throws {
        
        XCTAssertEqual(.float, Dummy.vertexFormat)
    }
    
    @available(macOS, unavailable) // intel macだとコンパイルが通らない
    @available(macCatalyst, unavailable)
    @available(iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    func testSmoke2() throws {
        
        XCTAssertEqual(.half, Float16.vertexFormat)
        
        let geom = SCNGeometry(primitiveType: .point) {
            #color<Float16>([])
        }
    }
    
    struct SmokeVertex2 {
        var float: Float
        var int: Int32
    }
    
    func testSmoke3() throws {
        
        let geom = SCNGeometry(primitiveType: .point) {
            #interleave<SmokeVertex2>([])
        }
    }
    
    struct SmokeVertex3 {
        var vector3: SCNVector3
        var vector4: SCNVector4
        var point: CGPoint
    }
    
#if !os(macOS) && !targetEnvironment(simulator)
    func testSmoke4() throws {
        
        if CGFloat.NativeType.self == Double.self {
            throw XCTSkip("[SceneKit] Error: geometrySourceWithData: interleaved buffers as doubles are not supported")
        }
        
        [SmokeVertex3]().geometrySources()
    }
#endif
    
    enum SmokeEnum {
        case a
        case b
    }
    
    func testSmoke5() throws {
        
        for flag in [true,false] {
            
            for e in [SmokeEnum.a, SmokeEnum.b] {
                
                let geom = SCNGeometry() {
                    if flag {
                        [SCNVector3]()
                    } else {
                        [SCNVector3]()
                    }
                    if flag {
                        [SCNVector3]()
                    }
                    SCNGeometryElement(indices: [Int](), primitiveType: .point)
                    print("Hello, world!")
                    for _ in 0..<3 {
                        [SCNVector3]()
                    }
                    if #available(macOS 10.15, *) {
                        
                    }
                    switch e {
                    case .a: [SCNVector3]()
                    default: [SCNVector3]()
                    }
                }
            }
        }
    }
    
    func testSmoke6() throws {
        
        let e = SmokeEnum.a
        
        for flag in [true,false] {
            
            for e in [SmokeEnum.a, SmokeEnum.b] {
                
                let geom = SCNGeometry(primitiveType: .point) {
                    if flag {
                        [SCNVector3]()
                    } else {
                        [SCNVector3]()
                    }
                    if flag {
                        [SCNVector3]()
                    }
                    print("Hello, world!")
                    for _ in 0..<3 {
                        [SCNVector3]()
                    }
                    if #available(macOS 10.15, *) {
                        
                    }
                    switch e {
                    case .a: [SCNVector3]()
                    default: [SCNVector3]()
                    }
                }
            }
        }
    }
    
    struct BasicVertex {
        var texcoord: CGPoint
        var position: SCNVector3
        var nameless: SCNVector3
    };
    
#if !os(macOS) && !targetEnvironment(simulator)
    func testCase4() throws {
        
        //        let vertices: [BasicVertex] = [
        //            .init(texcoord: .zero, position: .init(0, 0, 0), nameless: .init(0, 0, 0)),
        //            .init(texcoord: .zero, position: .init(0, 0, 0), nameless: .init(0, 0, 0)),
        //            .init(texcoord: .zero, position: .init(0, 0, 0), nameless: .init(0, 0, 0))
        //        ]
        
        if CGFloat.NativeType.self == Double.self {
            throw XCTSkip("[SceneKit] Error: geometrySourceWithData: interleaved buffers as doubles are not supported")
        }
        
        //        let geometry0: SCNGeometry = SCNGeometry(primitiveType: .triangles) {
        //            #interleave(vertices)
        //        }
        //
        //        let geometry1: SCNGeometry = SCNGeometry() {
        //            #interleave(vertices)
        //            #element<Int>(primitiveType: .triangles, [0,1,2])
        //        }
    }
#endif
    
    func testComponentsPerVector() throws {
        
        XCTAssertEqual(1, Int.componentsPerVector)
        XCTAssertEqual(1, Float.componentsPerVector)
    }
    
    func testOther() throws {
        
        XCTAssertNotNil(SCNGeometryElement(vectorCount: 0, primitiveType: .polygon))
        XCTAssertNotNil(SCNGeometryElement(vectorCount: 3, primitiveType: .polygon))
        
        XCTAssertEqual(2, 4.primitiveCount(of: .triangleStrip))
        XCTAssertEqual(2, 6.primitiveCount(of: .triangles))
        XCTAssertEqual(1, 6.primitiveCount(of: .polygon))
        XCTAssertEqual(3, 6.primitiveCount(of: .line))
        XCTAssertEqual(6, 6.primitiveCount(of: .point))
        
        let geom = SCNGeometry() {
            [Float]()
            [SmokeVertex]()
        }
        
        XCTAssertNotNil(SourceItem(sources: []))
        XCTAssertNotNil(ElementItem(elements:[]))
        XCTAssertEqual(2, SmokeVertex2.interleave.count)
    }
    
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}

extension SmokeTests.SmokeVertex: InterleavedVertex {
    static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
        [
            InterleaveAttribute(keyPath: \Self.float4, semantic: .vertex),
            InterleaveAttribute(keyPath: \Self.int4, semantic: .vertex),
            InterleaveAttribute(keyPath: \Self.uint4, semantic: .vertex),
            InterleaveAttribute(keyPath: \Self.short4, semantic: .vertex),
            InterleaveAttribute(keyPath: \Self.ushort4, semantic: .vertex),
            InterleaveAttribute(keyPath: \Self.char4, semantic: .vertex),
            InterleaveAttribute(keyPath: \Self.uchar4, semantic: .vertex),
        ]
    }
}

extension SmokeTests.SmokeVertex2: InterleavedVertex {
    static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
        [
            InterleaveAttribute(keyPath: \Self.float, semantic: .vertex),
            InterleaveAttribute(keyPath: \Self.int, semantic: .vertex),
        ]
    }
}

#if !os(macOS)
extension SmokeTests.SmokeVertex3: InterleavedVertex {
    static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
        [
            InterleaveAttribute(keyPath: \Self.vector3, semantic: .normal),
            InterleaveAttribute(keyPath: \Self.vector4, semantic: .vertex),
        ]
    }
}
#endif
