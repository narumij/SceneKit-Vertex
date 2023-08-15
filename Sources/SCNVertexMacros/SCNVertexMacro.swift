import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SCNVertexMacro { }

extension SCNVertexMacro: ExtensionMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        
        guard let _ = declaration.as(StructDeclSyntax.self) else {
            throw SCNVertexMacroError.notStructDeclSyntax
        }
        
        let interleaveAttributes = declaration.memberBlock.members.compactMap{ interleaveAttribute(of: $0) }
            .map{ $0.description }
        
        if interleaveAttributes.isEmpty {
            return []
        }
        
        return [try .init("extension \(type): SceneKit_Vertex.InterleavedVertex") {
            """
            static var interleave: [SceneKit_Vertex.InterleaveAttribute] { [
            \(raw: interleaveAttributes.joined(separator: ",\n") )
            ] }
            """
        }]
    }
    
    static func interleaveAttribute(of member: MemberBlockItemSyntax) -> SwiftSyntax.ExprSyntax? {
        
        if ignore(of: member) {
            return nil
        }
        
        guard
            let keyPath = keyPath(of: member),
            let semantic = semantic(of: member)
        else {
            return nil
        }
        
        let vertexFormat = vertexFormat(of: member) ?? "nil"
        
        return """
           SceneKit_Vertex.InterleaveAttribute( keyPath: \(keyPath), semantic: \(semantic), vertexFormat: \(vertexFormat) )
           """
    }
}

func semantic(of member: MemberBlockItemSyntax) -> SwiftSyntax.ExprSyntax? {
    
    guard let member = member.decl.as(VariableDeclSyntax.self),
          let path = member.bindings.first?.pattern.trimmedDescription
    else {
        return nil
    }
    
    let semantic: String = member.attributes?
        .compactMap{ $0.as(AttributeSyntax.self) }
        .filter{ $0.attributeName.description == AttributeMacro.custom }
        .compactMap {
            $0.arguments?.as(LabeledExprListSyntax.self)?
                .filter{ $0.label?.description == "semantic" }
                .map{ $0.expression }
                .first
        }
        .first?
        .description
    ?? "." + path
    
    return "\(raw: semantic == ".position" ? ".vertex" : semantic)"
}

func vertexFormat(of member: MemberBlockItemSyntax) -> SwiftSyntax.ExprSyntax? {
    
    guard let member = member.decl.as(VariableDeclSyntax.self),
          let attributes = member.attributes
    else {
        return nil
    }
    
    let format = attributes
        .compactMap{ $0.as(AttributeSyntax.self) }
        .filter{ $0.attributeName.description.trimmingCharacters(in: .whitespaces) == AttributeMacro.custom }
        .compactMap {
            $0.arguments?.as(LabeledExprListSyntax.self)?
                .filter{ $0.label?.description == "vertexFormat" }
                .map{ $0.expression }
                .first
        }
        .first
    
    return format
}

func keyPath(of member: MemberBlockItemSyntax) -> SwiftSyntax.ExprSyntax? {
    
    guard let member = member.decl.as(VariableDeclSyntax.self),
          let path = member.bindings.first?.pattern.trimmedDescription
    else {
        return nil
    }
    
    return "\\Self.\(raw: path)"
}

func ignore(of member: MemberBlockItemSyntax) -> Bool {
    
    guard let member = member.decl.as(VariableDeclSyntax.self)
    else {
        return false
    }
    
    let none = member.attributes?.compactMap{ $0.as(AttributeSyntax.self) }
        .contains { $0.attributeName.description.trimmingCharacters(in: .whitespaces) == AttributeMacro.none }
    
    if let none, none {
        return true
    }
    
    return false
}

