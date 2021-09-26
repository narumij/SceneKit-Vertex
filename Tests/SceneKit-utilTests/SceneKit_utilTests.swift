import XCTest
@testable import SceneKit_util

struct MyVertex: Position, Texcoord {
    let position: SIMD2<Float>
    let texcoord: SIMD2<Float>
}

extension MyVertex {
    static var positionKeyPath: PartialKeyPath<Self> { \Self.position }
    static var texcoordKeyPath: PartialKeyPath<Self> { \Self.texcoord }
}

struct HalfVertex: Semantic {
    let position: SIMD3<UInt16>
    let normal: SIMD3<UInt16>
}

extension HalfVertex {
    static var semanticDetail: [SemanticDetail] {
        [ (.vertex, .half3, MemoryLayout.offset(of: \Self.position)! ),
          (.normal, .half3, MemoryLayout.offset(of: \Self.normal)! ) ]
    }
}

extension Array where Element == MyVertex {
    init(_ seed:[((Float,Float),(Float,Float))] ) {
        self.init(seed.map{ .init(position: .init($0.0,$0.1), texcoord: .init($1.0,$1.0)) })
    }
}

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
        
        let geometries = [
            vertices0.geometry(with: device, primitiveType: .triangleStrip),
            vertices0.geometry(with: device, primitiveType: .line),
            vertices0.geometry(with: device, primitiveType: .point)]
        
    }
    
}


