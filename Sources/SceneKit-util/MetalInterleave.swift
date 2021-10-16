//
//  File.swift
//  
//
//  Created by narumij on 2021/10/16.
//

import Foundation

extension MetalInterleave {
    typealias VertexAttrib = MetalAttrb
}

public extension MetalInterleave
    where Self: Position,
          PositionType: VertexFormat
{
    static var metalAttributes: [MetalAttribute]
    {
        [metalPositionInfo]
    }
}

public extension MetalInterleave
    where Self: Position & Normal,
          PositionType: VertexFormat, NormalType: VertexFormat
{
    static var metalAttributes: [MetalAttribute]
    {
        [metalPositionInfo, metalNormalInfo]
    }
}

public extension MetalInterleave
    where Self: Position & Texcoord,
          PositionType: VertexFormat, TexcoordType: VertexFormat
{
    static var metalAttributes: [MetalAttribute]
    {
        [metalPositionInfo, metalTexcoordInfo]
    }
}

public extension MetalInterleave
    where Self: Position & Color,
          PositionType: VertexFormat, ColorType: VertexFormat
{
    static var metalAttributes: [MetalAttribute]
    {
        [metalPositionInfo, metalColorInfo]
    }
}

#if false
public extension MetalInterleave
    where Self: Position & Normal & Texcoord,
          PositionType: VertexFormat, NormalType: VertexFormat,
          TexcoordType: VertexFormat
{
    static var metalAttributes: [BasicAttribute]
    {
        [positionInfo, normalInfo, texcoordInfo]
    }
}

public extension MetalInterleave
    where Self: Position & Normal & Color,
          PositionType: VertexFormat, NormalType: VertexFormat,
          ColorType: VertexFormat
{
    static var metalAttributes: [BasicAttribute]
    {
        [positionInfo, normalInfo, colorInfo]
    }
}

public extension MetalInterleave
    where Self: Position & Texcoord & Color,
          PositionType: VertexFormat, TexcoordType: VertexFormat,
          ColorType: VertexFormat
{
    static var metalAttributes: [BasicAttribute]
    {
        [positionInfo, texcoordInfo, colorInfo]
    }
}

public extension MetalInterleave
    where Self: Position & Normal & Texcoord & Color,
          PositionType: VertexFormat, NormalType: VertexFormat,
          TexcoordType: VertexFormat, ColorType: VertexFormat
{
    static var metalAttributes: [BasicAttribute]
    {
        [positionInfo, normalInfo, texcoordInfo, colorInfo]
    }
}
#endif

