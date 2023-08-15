import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SourceArrayMacro { }

extension SourceArrayMacro: ExpressionMacro {
    
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let macro = node.macro.trimmedDescription
        let semantic = macro == "position" ? "vertex" : macro

        guard
            let type = node.genericArgumentClause?.arguments.first
        else {
            return "SceneKit_Vertex.GeometryBuilder.Source(separate: \(raw: node.argumentList.trimmedDescription), semantic: .\(raw: semantic))"
        }

        return "SceneKit_Vertex.GeometryBuilder.Source(separate: (\(raw: node.argumentList.trimmedDescription)) as [\(type)], semantic: .\(raw: semantic))"
    }
}

public struct SourceDataMacro { }

extension SourceDataMacro: ExpressionMacro {
    
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let macro = node.macro.trimmedDescription
        let semantic = macro == "position" ? "vertex" : macro

        guard
            let type = node.genericArgumentClause?.arguments.first
        else {
            return "SceneKit_Vertex.GeometryBuilder.Source(separate: \(raw: node.argumentList.trimmedDescription), semantic: .\(raw: semantic))"
        }
        
        return "SceneKit_Vertex.GeometryBuilder.Source(separate: TypedData<\(raw: type.trimmedDescription)>(\(raw: node.argumentList.trimmedDescription)), semantic: .\(raw: semantic))"
    }
}

public struct SourceBufferMacro { }

extension SourceBufferMacro: ExpressionMacro {
    
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let macro = node.macro.trimmedDescription
        let semantic = macro == "position" ? "vertex" : macro

        guard
            let type = node.genericArgumentClause?.arguments.first
        else {
            return "SceneKit_Vertex.GeometryBuilder.Source(separate: \(raw: node.argumentList.trimmedDescription), semantic: .\(raw: semantic))"
        }
        
        guard
            node.argumentList.contains(where: { $0.label?.description == "vertexFormat" }),
            let vertexFormat = node.argumentList.last?.expression else {
            
            return "SceneKit_Vertex.GeometryBuilder.Source(separate: TypedBuffer<\(raw: type.trimmedDescription)>(\(raw: node.argumentList.trimmedDescription)), semantic: .\(raw: semantic))"
        }
        
        var args = node.argumentList.filter{ $0.label?.description != "vertexFormat" }
        
        if let l = args.last, let i = args.index(of: l) {
            args[i].trailingComma = nil
        }

        return "SceneKit_Vertex.GeometryBuilder.Source(separate: TypedBuffer<\(raw: type.trimmedDescription)>(\(raw: args.map{ $0.description }.joined())), semantic: .\(raw: semantic), vertexFormat: \(raw: vertexFormat))"
    }
}
