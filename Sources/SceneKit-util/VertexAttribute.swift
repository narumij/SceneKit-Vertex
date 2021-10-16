//
//  File.swift
//  
//
//  Created by narumij on 2021/09/27.
//

import SceneKit
import Metal


public struct VertexKeyPath<VertexType>: KeyPathProperty {
    
    let keyPath: PartialKeyPath<VertexType>
    
    public var dataOffset: Int!
    {
        MemoryLayout<VertexType>.offset(of: keyPath)
    }
}

// MARK: -

public struct BasicAttrb: BasicAttribute {
    
    public init<T>(_ sm: Semantic,
                   _ keyPath: PartialKeyPath<T>,
                   usesFloatComponents ufc: Bool,
                   componentsPerVector cpv: Int,
                   bytesPerComponent bpc: Int)
    {
        semantic = sm
        vertexKeyPath = VertexKeyPath(keyPath: keyPath)
        usesFloatComponents = ufc
        componentsPerVector = cpv
        bytesPerComponent = bpc
    }
    
    public let semantic: Semantic
           let vertexKeyPath: KeyPathProperty
    public let usesFloatComponents: Bool
    public let componentsPerVector: Int
    public let bytesPerComponent:   Int
    public var dataOffset:          Int! { vertexKeyPath.dataOffset }
}

// MARK: -

public struct MetalAttrb: MetalAttribute {
    
    public init<T>(_ sm: Semantic,
                   _ vs: MTLVertexFormat,
                   _ keyPath: PartialKeyPath<T>)
    {
        semantic = sm
        vertexKeyPath = VertexKeyPath(keyPath: keyPath)
        vertexFormat = vs
    }
    
    public let semantic:      Semantic
           let vertexKeyPath: KeyPathProperty
    public let vertexFormat:  MTLVertexFormat
    public var dataOffset:    Int! { vertexKeyPath.dataOffset }
}

// MARK: -

public struct Attrb<AttributeType>: BasicAttrbFormat
    where AttributeType: BasicVertexDetail
{
    public init<T>(_ sm: Semantic,
                   _ keyPath: PartialKeyPath<T>)
    {
        semantic = sm
        keyPathOffset = VertexKeyPath<T>(keyPath: keyPath)
    }
    
    public let semantic:            Semantic
           let keyPathOffset:       KeyPathProperty
    public var usesFloatComponents: Bool { AttributeType.usesFloatComponents }
    public var componentsPerVector: Int  { AttributeType.componentsPerVector }
    public var bytesPerComponent:   Int  { AttributeType.bytesPerComponent }
    public var dataOffset:          Int! { keyPathOffset.dataOffset }
}

extension Attrb: MetalAttribute & MetalAttrbFormat
    where AttributeType: MetalVertexDetail
{
    public var vertexFormat: MTLVertexFormat
    {
        AttributeType.vertexFormat
    }
}

// MARK: -

extension Position
{
    static var positionInfo: BasicAttribute
    {
        Attrb<PositionType>(.vertex, positionKeyPath)
    }
}

extension Position
    where PositionType: VertexFormat
{
    static var metalPositionInfo: MetalAttribute
    {
         Attrb<PositionType>(.vertex, positionKeyPath)
    }
}

// MARK: -

extension Normal
{
    static var normalInfo: BasicAttribute
    {
        Attrb<NormalType>(.normal, normalKeyPath)
    }
    
}

extension Normal
    where NormalType: VertexFormat
{
    static var metalNormalInfo: MetalAttribute
    {
        Attrb<NormalType>(.normal, normalKeyPath)
    }
}

// MARK: -

extension Texcoord
{
    static var texcoordInfo: BasicAttribute
    {
        Attrb<TexcoordType>(.texcoord, texcoordKeyPath)
    }
}

extension Texcoord
    where TexcoordType: VertexFormat
{
    static var metalTexcoordInfo: MetalAttribute
    {
        Attrb<TexcoordType>(.texcoord, texcoordKeyPath)
    }
}

// MARK: -

extension Color
{
    static var colorInfo: BasicAttribute
    {
        Attrb<ColorType>(.color, colorKeyPath)
    }
}

extension Color
    where ColorType: VertexFormat
{
    static var metalColorInfo: MetalAttribute
    {
        Attrb<ColorType>(.color, colorKeyPath)
    }
}

