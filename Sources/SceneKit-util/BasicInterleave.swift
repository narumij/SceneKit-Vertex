//
//  File.swift
//  
//
//  Created by narumij on 2021/10/16.
//

import Foundation

extension BasicInterleave
    where Self: Position
{
    static var basicAttributes: [BasicAttribute]
    {
        [positionInfo]
    }
}

public extension BasicInterleave
    where Self: Position & Normal
{
    static var basicAttributes: [BasicAttribute]
    {
        [positionInfo, normalInfo]
    }
}

public extension BasicInterleave
    where Self: Position & Texcoord
{
    static var basicAttributes: [BasicAttribute]
    {
        [positionInfo, texcoordInfo]
    }
}

public extension BasicInterleave
    where Self: Position & Color
{
    static var basicAttributes: [BasicAttribute]
    {
        [positionInfo, colorInfo]
    }
}

#if false
public extension BasicInterleave
    where Self: Position & Normal & Texcoord
{
    static var basicAttributes: [BasicAttribute]
    {
        [positionInfo, normalInfo, texcoordInfo]
    }
}

public extension BasicInterleave where Self: Position & Normal & Color
{
    static var basicAttributes: [BasicAttribute]
    {
        [positionInfo, normalInfo, colorInfo]
    }
}

public extension BasicInterleave where Self: Position & Texcoord & Color
{
    static var basicAttributes: [BasicAttribute]
    {
        [positionInfo, texcoordInfo, colorInfo]
    }
}

public extension BasicInterleave where Self: Position & Normal & Texcoord & Color
{
    static var basicAttributes: [BasicAttribute]
    {
        [positionInfo, normalInfo, texcoordInfo, colorInfo]
    }
}
#endif

