//
//  Created by narumij on 2023/06/12.
//

import SceneKit

extension SCNGeometryElement {
    
    convenience init(vectorCount count: Int, primitiveType type: SCNGeometryPrimitiveType) {
        
        switch type {
        case .polygon:
            self.init(indices: count == 0 ? [] : ([count] + (0..<count)).map{ UInt32($0) },
                      primitiveType: .polygon,
                      primitiveCount: count == 0 ? 0 : 1)
        default:
            self.init(indices: (0..<Int32(count)).map{ $0 }, primitiveType: type)
        }
    }
}

extension SCNGeometryElement {
    
    convenience init<Index>(indices: [Index], primitiveType: SCNGeometryPrimitiveType, primitiveCount: Int) where Index: FixedWidthInteger {
        self.init(data: indices.data,
                  primitiveType: primitiveType,
                  primitiveCount: primitiveCount,
                  bytesPerIndex: MemoryLayout<Index>.size)
    }
}
