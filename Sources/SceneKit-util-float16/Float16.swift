//
//  File.swift
//  
//
//  Created by narumij on 2021/10/16.
//

import Foundation

#if false

extension Float16
{
    public static var vertexFormat: MTLVertexFormat { .half }

    public static var vertexFormatArray: [MTLVertexFormat]
    {
        [ .half2, .half3, .half4 ]
    }
}

extension Float16: BasicVertexDetail & VertexScalar { }

#endif

