import XCTest
@testable import SceneKit_util
import SceneKit

struct MyVertex: Position, Texcoord {
    let position: SIMD2<Float>
    let texcoord: SIMD2<Float>
}

extension MyVertex {
    static var positionKeyPath: PartialKeyPath<Self> { \Self.position }
    static var texcoordKeyPath: PartialKeyPath<Self> { \Self.texcoord }
}

struct HalfVertex: Interleave {
    let position: SIMD3<UInt16>
    let normal: SIMD3<UInt16>
}

extension HalfVertex {
    static var semanticDetails: [SemanticDetail] {
        [ (.vertex, .half3, true, 3, 2, MemoryLayout.offset(of: \Self.position)! ),
          (.normal, .half3, true, 3, 2, MemoryLayout.offset(of: \Self.normal)! ) ]
    }
}

extension Array where Element == MyVertex {
    init(_ seed:[((Float,Float),(Float,Float))] ) {
        self.init(seed.map{ .init(position: .init($0.0,$0.1), texcoord: .init($1.0,$1.0)) })
    }
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


