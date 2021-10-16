//
//  File.swift
//  
//
//  Created by narumij on 2021/10/14.
//

import SceneKit


public protocol VertexScalar
{
    static var vertexFormatArray: [MTLVertexFormat] { get }
}

// MARK: -

public protocol UsesFloatComponents
{
    static var usesFloatComponents: Bool { get }
}

public protocol BytesPerComponent
{
    static var bytesPerComponent: Int { get }
}

public protocol ComponentsPerVecotr
{
    static var componentsPerVector: Int { get }
}

public typealias BasicVertexDetail
    = UsesFloatComponents
    & BytesPerComponent
    & ComponentsPerVecotr

public protocol VertexFormat
{
    static var vertexFormat: MTLVertexFormat { get }
}

public typealias MetalVertexDetail
    = UsesFloatComponents
    & BytesPerComponent
    & ComponentsPerVecotr
    & VertexFormat


// MARK: -

public protocol KeyPathProperty {
    var dataOffset: Int! { get }
}

public protocol AttributeFormatTraits {
    typealias Semantic = SCNGeometrySource.Semantic
    var semantic: Semantic { get }
}

public protocol BasicAttribute: AttributeFormatTraits
{
    var usesFloatComponents: Bool { get }
    var componentsPerVector: Int  { get }
    var bytesPerComponent:   Int  { get }
    var dataOffset:          Int! { get }
}

public protocol MetalAttribute: AttributeFormatTraits
{
    var vertexFormat: MTLVertexFormat { get }
    var dataOffset:  Int!             { get }
}

// MARK: -

public protocol AttrbFormat {
    associatedtype AttributeType
}

public protocol BasicAttrbFormat: AttrbFormat & BasicAttribute
    where AttributeType: BasicVertexDetail { }

public protocol MetalAttrbFormat: AttrbFormat & MetalAttribute
    where AttributeType: MetalVertexDetail { }


// MARK: -

public protocol Interleave { }

public protocol BasicInterleave: Interleave
{
    static var basicAttributes: [BasicAttribute] { get }
}

public protocol MetalInterleave: Interleave
{
    static var metalAttributes: [MetalAttribute] { get }
}

public protocol FullInterleave: BasicInterleave & MetalInterleave { }

// MARK: -


public protocol CommonTraits {
    typealias AttrbKeyPath = PartialKeyPath<Self>
}


// MARK: -

public protocol Position: CommonTraits
{
    associatedtype PositionType: BasicVertexDetail, SIMD
    
           var position:        PositionType { get }
    static var positionKeyPath: AttrbKeyPath { get }
}

public protocol Normal: CommonTraits
{
    associatedtype NormalType: BasicVertexDetail, SIMD
    
           var normal:        NormalType { get }
    static var normalKeyPath: AttrbKeyPath { get }
}

public protocol Texcoord: CommonTraits
{
    associatedtype TexcoordType: BasicVertexDetail
    
           var texcoord:        TexcoordType { get }
    static var texcoordKeyPath: AttrbKeyPath { get }
}

public protocol Color: CommonTraits
{
    associatedtype ColorType: BasicVertexDetail
    
           var color:        ColorType { get }
    static var colorKeyPath: PartialKeyPath<Self> { get }
}

