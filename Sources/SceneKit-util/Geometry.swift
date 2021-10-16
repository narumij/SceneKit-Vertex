//
//  File.swift
//  
//
//  Created by narumij on 2021/09/26.
//

import SceneKit


public protocol Geometry
{
    /// 引数で指定された描画プリミティブでの描画を行うSCNGeometryを生成する
    func geometry(primitiveType type: PrimitiveType) -> SCNGeometry?
    
    /// 引数で与えられた、頂点インデックス配列と描画プリミティブの組み合わせを持ったSCNGeometryを生成する
    func geometry<T: FixedWidthInteger>(elements: [([T], SCNGeometryPrimitiveType)]) -> SCNGeometry
    
    /// 引数で与えられた、頂点インデックスバッファと描画プリミティブの組み合わせを持ったSCNGeometryを生成する
    func geometry<T: FixedWidthInteger>(elements: [(TypedBuffer<T>, SCNGeometryPrimitiveType)]) -> SCNGeometry
}


extension GeometrySource {

    public func geometry(primitiveType type: PrimitiveType) -> SCNGeometry?
    {
        geometryElement(primitiveType: type)
            .map{ SCNGeometry( sources: geometrySources(),
                               elements: [$0] ) }
    }

    public func geometry<T: FixedWidthInteger>(elements: [([T], SCNGeometryPrimitiveType)]) -> SCNGeometry
    {
        SCNGeometry( sources: geometrySources(),
                     elements: elements.map{ $0.geometryElement(primitiveType: $1 ) })
    }
    
    public func geometry<T: FixedWidthInteger>(elements: [(TypedBuffer<T>, SCNGeometryPrimitiveType)]) -> SCNGeometry
    {
        SCNGeometry( sources: geometrySources(),
                     elements: elements.map{ $0.geometryElement(primitiveType: $1) } )
    }
    
}


extension Interleaved: Geometry { }
extension Separated:   Geometry { }

