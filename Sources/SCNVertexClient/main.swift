import SceneKit
import SceneKit_Vertex

@SCNVertex struct V {
    var position: SIMD3<Float>
    static var normal: SIMD3<Float> = .zero
}
